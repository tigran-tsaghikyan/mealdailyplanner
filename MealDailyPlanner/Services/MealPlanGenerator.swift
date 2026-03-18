import Foundation

protocol MealPlanGenerating {
    func generatePlan(for date: Date, profile: UserProfile) -> DailyPlan
}

final class MealPlanGenerator: MealPlanGenerating {
    private let recipes: [Recipe]
    private let cookingFlowGenerator = CookingFlowGenerator()

    init(recipes: [Recipe] = RecipeDatabase.all) {
        self.recipes = recipes
    }

    func generatePlan(for date: Date, profile: UserProfile) -> DailyPlan {
        let seed = daySeed(from: date)
        let filtered = filterRecipes(profile: profile)

        let breakfasts = filtered.filter { $0.mealType == .breakfast }
        let lunches = filtered.filter { $0.mealType == .lunch }
        let dinners = filtered.filter { $0.mealType == .dinner }

        let breakfast = selectRecipe(from: breakfasts, seed: seed, offset: 0)
        let lunch = selectRecipe(from: lunches, seed: seed, offset: 1)
        let dinner = selectRecipe(from: dinners, seed: seed, offset: 2)

        let selectedRecipes = [breakfast, lunch, dinner].compactMap { $0 }
        let optimized = optimizeForSharedIngredients(selectedRecipes, allBreakfasts: breakfasts, allLunches: lunches, allDinners: dinners, seed: seed)

        let multiplier = profile.scalingMultiplier
        let meals = optimized.map { recipe in
            scaledMeal(from: recipe, multiplier: multiplier)
        }

        let flow = cookingFlowGenerator.generateFlow(from: optimized, multiplier: multiplier)
        let totalTime = min(flow.map(\.durationMinutes).reduce(0, +), 30)

        return DailyPlan(
            date: date,
            meals: meals,
            cookingFlow: flow,
            totalCookingTimeMinutes: totalTime
        )
    }

    // MARK: - Private

    private func daySeed(from date: Date) -> Int {
        let calendar = Calendar.current
        let day = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        return day
    }

    private func filterRecipes(profile: UserProfile) -> [Recipe] {
        var filtered = recipes.filter { !$0.containsAllergen(profile.allergies) }

        if !profile.availableIngredients.isEmpty {
            let available = Set(profile.availableIngredients.map { $0.lowercased() })
            let withAvailable = filtered.filter { recipe in
                let recipeIngredients = recipe.ingredientNames
                let overlap = recipeIngredients.intersection(available)
                return !overlap.isEmpty
            }
            if withAvailable.count >= 3 {
                filtered = withAvailable
            }
        }

        return filtered
    }

    private func selectRecipe(from recipes: [Recipe], seed: Int, offset: Int) -> Recipe? {
        guard !recipes.isEmpty else { return nil }
        let index = abs((seed * 31 + offset * 17) % recipes.count)
        return recipes[index]
    }

    private func optimizeForSharedIngredients(
        _ selected: [Recipe],
        allBreakfasts: [Recipe],
        allLunches: [Recipe],
        allDinners: [Recipe],
        seed: Int
    ) -> [Recipe] {
        guard selected.count == 3 else { return selected }

        let totalTime = selected.reduce(0) { $0 + $1.prepTimeMinutes }
        if totalTime <= 30 { return selected }

        // If over 30 min, try to find faster alternatives
        var result = selected
        let pools: [[Recipe]] = [allBreakfasts, allLunches, allDinners]

        for i in 0..<3 {
            let currentTime = result.reduce(0) { $0 + $1.prepTimeMinutes }
            if currentTime <= 30 { break }

            let others = pools[i].filter { $0.prepTimeMinutes < result[i].prepTimeMinutes }
            if let faster = others.first {
                result[i] = faster
            }
        }

        return result
    }

    private func scaledMeal(from recipe: Recipe, multiplier: Double) -> Meal {
        let scaledIngredients = recipe.ingredients.map { ingredient in
            MealIngredient(
                name: ingredient.name,
                baseGrams: ingredient.baseGrams * multiplier,
                unit: ingredient.unit
            )
        }

        return Meal(
            type: recipe.mealType,
            title: recipe.title,
            ingredients: scaledIngredients,
            steps: recipe.steps,
            prepTimeMinutes: recipe.prepTimeMinutes
        )
    }
}
