import Foundation
import SwiftUI
import WidgetKit

final class DailyPlanViewModel: ObservableObject {
    @Published var dailyPlan: DailyPlan?
    @Published var isLoading = false
    @Published var remainingRefreshes: Int = 3
    @Published var generatedLocally = false  // true when API failed, local fallback used

    static let maxDailyRefreshes = 3

    private let generator: MealPlanGenerating
    private let apiService = MealPlanAPIService.shared
    private let storage = StorageManager.shared

    init(generator: MealPlanGenerating = MealPlanGenerator()) {
        self.generator = generator
        loadRefreshState()
        loadOrGenerate()
    }

    // MARK: - Load / Generate

    func loadOrGenerate() {
        if storage.hasPlanForToday(), let existing = storage.loadDailyPlan() {
            dailyPlan = existing
            return
        }
        startGeneration()
    }

    /// Force-generates a fresh plan — called after onboarding completes.
    func generateForce() {
        startGeneration()
    }

    // MARK: - Pro Refresh (max 3/day, resets at midnight)

    var canRefresh: Bool { remainingRefreshes > 0 }

    func refresh() {
        guard canRefresh else { return }
        remainingRefreshes -= 1
        storage.saveRefreshCount(Self.maxDailyRefreshes - remainingRefreshes)
        startGeneration()
    }

    private func loadRefreshState() {
        let used = storage.loadRefreshCount()
        remainingRefreshes = max(0, Self.maxDailyRefreshes - used)
    }

    // MARK: - Core Generation (API → local fallback)

    private func startGeneration() {
        isLoading = true
        generatedLocally = false

        Task {
            await generateTodaysPlan()
        }
    }

    @MainActor
    private func generateTodaysPlan() async {
        let profile = storage.loadProfile()

        // 1️⃣ Try OpenAI API
        if let meals = try? await apiService.generateMeals(profile: profile) {
            let plan = buildPlan(meals: meals, date: Date(), profile: profile)
            storage.saveDailyPlan(plan)
            dailyPlan = plan
            generatedLocally = false
            isLoading = false
            WidgetCenter.shared.reloadAllTimelines()
            return
        }

        // 2️⃣ Fallback: local generation
        let plan = generator.generatePlan(for: Date(), profile: profile)
        storage.saveDailyPlan(plan)
        dailyPlan = plan
        generatedLocally = true
        isLoading = false
        WidgetCenter.shared.reloadAllTimelines()
    }

    // MARK: - Build DailyPlan from API meals

    private func buildPlan(meals: [Meal], date: Date, profile: UserProfile) -> DailyPlan {
        // Reuse existing cooking flow generator with a neutral multiplier
        // (API meals already have correct ingredient amounts for the family)
        let cookingFlow = buildCookingFlow(from: meals)
        let totalTime = meals.reduce(0) { $0 + $1.prepTimeMinutes }

        return DailyPlan(
            date: date,
            meals: meals,
            cookingFlow: cookingFlow,
            totalCookingTimeMinutes: min(totalTime, 30)
        )
    }

    private func buildCookingFlow(from meals: [Meal]) -> [CookingStep] {
        var steps: [CookingStep] = []
        var stepNumber = 1

        for meal in meals {
            for step in meal.steps {
                steps.append(CookingStep(
                    stepNumber: stepNumber,
                    description: "[\(meal.type.rawValue)] \(step)",
                    durationMinutes: max(1, meal.prepTimeMinutes / max(meal.steps.count, 1))
                ))
                stepNumber += 1
            }
        }
        return steps
    }
}
