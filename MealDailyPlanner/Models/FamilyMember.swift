import Foundation

struct FamilyMember: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var isChild: Bool
    var nutritionTargets: NutritionMetrics?
    var bodyMetrics: BodyMetrics?

    var scalingFactor: Double {
        isChild ? 0.5 : 1.0
    }

    var hasNutritionTargets: Bool {
        nutritionTargets != nil
    }
}
