import Foundation

final class CookingFlowGenerator {
    func generateFlow(from recipes: [Recipe], multiplier: Double) -> [CookingStep] {
        guard !recipes.isEmpty else { return [] }

        var steps: [CookingStep] = []
        var stepNumber = 1

        // Find shared ingredients across meals
        let allIngredients = recipes.flatMap { $0.ingredientNames }
        let ingredientCounts = Dictionary(allIngredients.map { ($0, 1) }, uniquingKeysWith: +)
        let sharedIngredients = ingredientCounts.filter { $0.value > 1 }.map { $0.key }

        // Step 1: Start longest cooking items first
        let sortedByTime = recipes.sorted { $0.prepTimeMinutes > $1.prepTimeMinutes }
        let needsBoiling = recipes.filter { recipe in
            recipe.ingredientNames.contains("rice") ||
            recipe.ingredientNames.contains("pasta") ||
            recipe.ingredientNames.contains("spaghetti") ||
            recipe.ingredientNames.contains("quinoa") ||
            recipe.ingredientNames.contains("couscous") ||
            recipe.ingredientNames.contains("red lentils")
        }

        if !needsBoiling.isEmpty {
            let grains = needsBoiling.flatMap { recipe in
                recipe.ingredients.filter {
                    ["rice", "pasta", "spaghetti", "quinoa", "couscous", "red lentils"]
                        .contains($0.name.lowercased())
                }
            }
            let grainNames = grains.map { "\($0.name) (\($0.scaled(for: multiplier)))" }.joined(separator: ", ")
            steps.append(CookingStep(
                stepNumber: stepNumber,
                description: "Start boiling water and cook \(grainNames)",
                durationMinutes: 2
            ))
            stepNumber += 1
        }

        // Step 2: Prep shared ingredients
        if !sharedIngredients.isEmpty {
            let needsChopping = sharedIngredients.filter { name in
                ["bell pepper", "tomato", "cucumber", "onion", "carrot", "zucchini",
                 "broccoli", "lettuce", "garlic", "potato", "mushrooms"]
                    .contains(name)
            }
            if !needsChopping.isEmpty {
                steps.append(CookingStep(
                    stepNumber: stepNumber,
                    description: "Chop shared vegetables: \(needsChopping.joined(separator: ", "))",
                    durationMinutes: 3
                ))
                stepNumber += 1
            }
        }

        // Step 3-N: Generate per-meal steps
        for recipe in sortedByTime {
            let uniqueSteps = recipe.steps.filter { step in
                let lower = step.lowercased()
                // Skip steps already covered by shared prep
                if !sharedIngredients.isEmpty {
                    if (lower.contains("chop") || lower.contains("dice") || lower.contains("slice")) &&
                       sharedIngredients.contains(where: { lower.contains($0) }) {
                        return false
                    }
                }
                // Skip boiling step if already added
                if !needsBoiling.isEmpty &&
                   (lower.contains("boil") || lower.contains("cook rice") || lower.contains("cook pasta") || lower.contains("cook quinoa")) {
                    return false
                }
                return true
            }

            for step in uniqueSteps {
                steps.append(CookingStep(
                    stepNumber: stepNumber,
                    description: "[\(recipe.mealType.rawValue)] \(step)",
                    durationMinutes: max(1, recipe.prepTimeMinutes / max(recipe.steps.count, 1))
                ))
                stepNumber += 1
            }
        }

        return steps
    }
}
