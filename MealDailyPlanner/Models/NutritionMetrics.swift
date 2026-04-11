import Foundation

struct NutritionMetrics: Codable, Hashable {
    var calories: Double  // kcal/day
    var protein: Double   // g/day
    var fat: Double       // g/day
    var carbs: Double     // g/day

    static let zero = NutritionMetrics(calories: 0, protein: 0, fat: 0, carbs: 0)
}
