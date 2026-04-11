import Foundation

final class StorageManager {
    static let shared = StorageManager()

    private let suiteName = "group.com.mealdailyplanner.app"
    private let profileKey          = "userProfile"
    private let dailyPlanKey        = "dailyPlan"
    private let planDateKey         = "planDate"
    private let onboardingKey       = "hasCompletedOnboarding"
    private let refreshCountKey     = "dailyRefreshCount"
    private let refreshDateKey      = "dailyRefreshDate"

    private var defaults: UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }

    private init() {}

    // MARK: - Onboarding

    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: onboardingKey) }
        set { defaults.set(newValue, forKey: onboardingKey) }
    }

    // MARK: - Daily Refresh Counter

    /// Returns how many refreshes have been used today (resets automatically if it's a new day).
    func loadRefreshCount() -> Int {
        guard let date = defaults.object(forKey: refreshDateKey) as? Date,
              Calendar.current.isDateInToday(date) else {
            return 0
        }
        return defaults.integer(forKey: refreshCountKey)
    }

    func saveRefreshCount(_ count: Int) {
        defaults.set(count, forKey: refreshCountKey)
        defaults.set(Date(), forKey: refreshDateKey)
    }

    // MARK: - Profile

    func saveProfile(_ profile: UserProfile) {
        if let data = try? JSONEncoder().encode(profile) {
            defaults.set(data, forKey: profileKey)
        }
    }

    func loadProfile() -> UserProfile {
        guard let data = defaults.data(forKey: profileKey),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return .default
        }
        return profile
    }

    // MARK: - Daily Plan

    func saveDailyPlan(_ plan: DailyPlan) {
        if let data = try? JSONEncoder().encode(plan) {
            defaults.set(data, forKey: dailyPlanKey)
            defaults.set(plan.date.timeIntervalSince1970, forKey: planDateKey)
        }
    }

    func loadDailyPlan() -> DailyPlan? {
        guard let data = defaults.data(forKey: dailyPlanKey),
              let plan = try? JSONDecoder().decode(DailyPlan.self, from: data) else {
            return nil
        }
        return plan
    }

    func hasPlanForToday() -> Bool {
        guard let plan = loadDailyPlan() else { return false }
        return Calendar.current.isDateInToday(plan.date)
    }
}
