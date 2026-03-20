import Foundation
import StoreKit

enum SubscriptionStatus: String {
    case free = "Free Trial"
    case expired = "Trial Expired"
    case pro = "Pro"
}

@MainActor
final class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()

    static let monthlyProductID = "com.mealdailyplanner.app.monthly"
    private let trialKey = "trialStartDate"
    private let trialDurationSeconds: TimeInterval = 86400 // 24 hours

    @Published var status: SubscriptionStatus = .free
    @Published var product: Product?
    @Published var isLoading = false
    @Published var subscriptionExpirationDate: Date?

    private var updateTask: Task<Void, Never>?

    private init() {
        updateTask = Task { await listenForTransactions() }
    }

    deinit {
        updateTask?.cancel()
    }

    // MARK: - Trial

    var trialStartDate: Date {
        let defaults = UserDefaults.standard
        if let saved = defaults.object(forKey: trialKey) as? Date {
            return saved
        }
        let now = Date()
        defaults.set(now, forKey: trialKey)
        return now
    }

    var trialEndDate: Date {
        trialStartDate.addingTimeInterval(trialDurationSeconds)
    }

    var isTrialActive: Bool {
        Date() < trialEndDate
    }

    var trialRemainingText: String {
        let remaining = trialEndDate.timeIntervalSince(Date())
        if remaining <= 0 { return "Expired" }
        let hours = Int(remaining / 3600)
        let minutes = Int((remaining.truncatingRemainder(dividingBy: 3600)) / 60)
        if hours > 0 {
            return "\(hours)h \(minutes)m remaining"
        }
        return "\(minutes)m remaining"
    }

    // MARK: - Subscription Check

    func checkStatus() async {
        // Check for active subscription
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.monthlyProductID {
                subscriptionExpirationDate = transaction.expirationDate
                status = .pro
                return
            }
        }

        // No active subscription - check trial
        subscriptionExpirationDate = nil
        status = isTrialActive ? .free : .expired
    }

    var subscriptionExpirationText: String? {
        guard let date = subscriptionExpirationDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return "Renews \(formatter.string(from: date))"
    }

    var canAccessApp: Bool {
        status == .pro || (status == .free && isTrialActive)
    }

    // MARK: - Products

    func loadProducts() async {
        isLoading = true
        do {
            let products = try await Product.products(for: [Self.monthlyProductID])
            product = products.first
        } catch {
            // Product loading failed - user can still use trial
        }
        isLoading = false
    }

    // MARK: - Purchase

    func purchase() async -> Bool {
        guard let product else { return false }
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    subscriptionExpirationDate = transaction.expirationDate
                    status = .pro
                    return true
                }
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            // Purchase failed
        }
        return false
    }

    func restorePurchases() async {
        isLoading = true
        try? await AppStore.sync()
        await checkStatus()
        isLoading = false
    }

    // MARK: - Transaction Listener

    private func listenForTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                await transaction.finish()
                await checkStatus()
            }
        }
    }
}
