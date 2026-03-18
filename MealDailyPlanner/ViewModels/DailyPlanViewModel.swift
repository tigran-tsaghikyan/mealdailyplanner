import Foundation
import SwiftUI
import WidgetKit

final class DailyPlanViewModel: ObservableObject {
    @Published var dailyPlan: DailyPlan?
    @Published var isLoading = false

    private let generator: MealPlanGenerating
    private let storage = StorageManager.shared

    init(generator: MealPlanGenerating = MealPlanGenerator()) {
        self.generator = generator
        loadOrGenerate()
    }

    func loadOrGenerate() {
        if storage.hasPlanForToday(), let existing = storage.loadDailyPlan() {
            dailyPlan = existing
            return
        }
        generateTodaysPlan()
    }

    private func generateTodaysPlan() {
        isLoading = true
        let profile = storage.loadProfile()
        let plan = generator.generatePlan(for: Date(), profile: profile)
        storage.saveDailyPlan(plan)
        dailyPlan = plan
        isLoading = false
        WidgetCenter.shared.reloadAllTimelines()
    }
}
