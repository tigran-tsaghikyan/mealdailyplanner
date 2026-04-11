import Foundation

// MARK: - Member Portion

struct MemberPortion: Identifiable {
    var id: UUID { member.id }
    let member: FamilyMember
    let portionFactor: Double      // multiplier applied to baseGrams of each ingredient
    let caloriesPerMeal: Double?   // nil when using default fallback
    let isDefaultPortion: Bool     // true = unconfigured child using safe ½ base

    /// Formatted calorie label, nil if unconfigured
    var caloriesLabel: String? {
        guard let cal = caloriesPerMeal else { return nil }
        return "~\(Int(cal)) kcal"
    }

    /// Human-readable portion description for the UI
    var portionDescription: String {
        if isDefaultPortion {
            return "½ safe default portion"
        } else if caloriesPerMeal != nil {
            return "Based on personal targets"
        } else {
            return "Standard portion"
        }
    }
}

// MARK: - Portion Calculator

struct PortionCalculator {

    /// Reference daily calories for one standard adult (no config).
    /// Used to scale configured members relative to a neutral base.
    private static let baseAdultCaloriesPerDay: Double = 2000.0
    private static let mealsPerDay: Double = 3.0

    // MARK: - Public API

    /// Returns a `MemberPortion` for every family member for a given meal.
    static func portions(for members: [FamilyMember]) -> [MemberPortion] {
        members.map { portion(for: $0) }
    }

    // MARK: - Per-member Logic

    static func portion(for member: FamilyMember) -> MemberPortion {
        if let targets = member.nutritionTargets {
            // ── Configured member (adult OR child) ──
            // portionFactor is relative to a 2000 kcal/day adult base.
            // e.g. 3000 kcal adult → factor 1.5 (gets 1.5× base ingredients)
            //      1400 kcal child → factor 0.7 (gets 0.7× base ingredients)
            let caloriesPerMeal = targets.calories / mealsPerDay
            let portionFactor   = targets.calories / baseAdultCaloriesPerDay

            return MemberPortion(
                member: member,
                portionFactor: portionFactor,
                caloriesPerMeal: caloriesPerMeal,
                isDefaultPortion: false
            )
        } else {
            // ── Unconfigured member ──
            // Adults  → 1.0× recipe base (no assumptions)
            // Children → 0.5× recipe base (safe default, decoupled from any adult's targets)
            return MemberPortion(
                member: member,
                portionFactor: member.scalingFactor,
                caloriesPerMeal: nil,
                isDefaultPortion: member.isChild
            )
        }
    }
}
