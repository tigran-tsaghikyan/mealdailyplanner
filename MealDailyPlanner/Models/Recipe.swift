import Foundation

struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let mealType: MealType
    let ingredients: [MealIngredient]
    let steps: [String]
    let prepTimeMinutes: Int
    let tags: Set<String>

    var ingredientNames: Set<String> {
        Set(ingredients.map { $0.name.lowercased() })
    }

    func containsAllergen(_ allergies: [String]) -> Bool {
        let lowerAllergies = Set(allergies.map { $0.lowercased() })
        return !ingredientNames.isDisjoint(with: lowerAllergies)
    }
}
