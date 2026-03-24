import SwiftUI

struct PaywallView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager

    private let privacyPolicyURL = URL(string: "https://tigran-tsaghikyan.github.io/mealdailyplanner/privacy-policy.html")!
    private let termsOfUseURL = URL(string: "https://tigran-tsaghikyan.github.io/mealdailyplanner/terms-of-use.html")!

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.spacingLG) {
                Spacer(minLength: 30)

                Image(systemName: "fork.knife.circle")
                    .font(.system(size: 64))
                    .foregroundColor(AppTheme.primary)

                Text("Meal Daily Planner")
                    .font(AppTheme.largeTitleFont)

                Text("Your free trial has ended.\nSubscribe to continue generating daily meal plans.")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.spacingLG)

                // Subscription details (required by App Store)
                VStack(spacing: 6) {
                    Text("Premium Plan")
                        .font(AppTheme.headlineFont)

                    if let product = subscriptionManager.product {
                        Text("\(product.displayPrice) / month")
                            .font(AppTheme.titleFont)
                    } else {
                        Text("$3.99 / month")
                            .font(AppTheme.titleFont)
                    }

                    Text("Auto-renewable monthly subscription\nCancel anytime")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.secondary)
                        .multilineTextAlignment(.center)
                }

                // Subscribe button
                Button {
                    Task { await subscriptionManager.purchase() }
                } label: {
                    Text("Subscribe")
                        .font(AppTheme.headlineFont)
                        .foregroundColor(Color(.systemBackground))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(AppTheme.primary)
                        .cornerRadius(12)
                }
                .disabled(subscriptionManager.isLoading)
                .padding(.horizontal, AppTheme.spacingLG)

                // Restore purchases
                Button {
                    Task { await subscriptionManager.restorePurchases() }
                } label: {
                    Text("Restore Purchases")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.secondary)
                }

                // Subscription terms text (required by App Store 3.1.2c)
                Text("Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless canceled at least 24 hours before the end of the current period.")
                    .font(.system(size: 11))
                    .foregroundColor(Color(.tertiaryLabel))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.spacingLG)

                // Legal links (required by App Store 3.1.2c)
                HStack(spacing: 16) {
                    Link("Privacy Policy", destination: privacyPolicyURL)
                    Text("·")
                        .foregroundColor(Color(.tertiaryLabel))
                    Link("Terms of Use", destination: termsOfUseURL)
                }
                .font(.system(size: 12))

                Spacer(minLength: 20)
            }
        }
    }
}
