import Foundation

enum MealType: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
}

struct MealIngredient: Codable, Identifiable, Hashable {
    var id = UUID()
    let name: String
    let baseGrams: Double
    let unit: String

    func scaled(for multiplier: Double) -> String {
        let amount = baseGrams * multiplier
        if amount >= 1000 && unit == "g" {
            return String(format: "%.1f kg", amount / 1000)
        }
        if amount == floor(amount) {
            return "\(Int(amount)) \(unit)"
        }
        return String(format: "%.0f \(unit)", amount)
    }
}

struct Meal: Codable, Identifiable {
    var id = UUID()
    let type: MealType
    let title: String
    let ingredients: [MealIngredient]
    let steps: [String]
    let prepTimeMinutes: Int
}

struct CookingStep: Codable, Identifiable {
    var id = UUID()
    let stepNumber: Int
    let description: String
    let durationMinutes: Int
}

struct DailyPlan: Codable {
    let date: Date
    let meals: [Meal]
    let cookingFlow: [CookingStep]
    let totalCookingTimeMinutes: Int

    var breakfast: Meal? { meals.first { $0.type == .breakfast } }
    var lunch: Meal? { meals.first { $0.type == .lunch } }
    var dinner: Meal? { meals.first { $0.type == .dinner } }

    static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .full
        return f
    }()

    var formattedDate: String {
        Self.dateFormatter.string(from: date)
    }
}
