import Foundation

struct MetricsCalculator {

    // MARK: - Main Calculation (Mifflin-St Jeor + TDEE)

    static func calculate(from metrics: BodyMetrics) -> NutritionMetrics {
        let bmr  = basalMetabolicRate(metrics)
        let tdee = bmr * metrics.activityLevel.multiplier

        // Apply goal adjustment
        let targetCalories = (tdee * metrics.goal.tdeeMultiplier).rounded()

        // Macro split: Protein 25% | Fat 30% | Carbs 45%
        let protein = ((targetCalories * 0.25) / 4).rounded()  // 4 kcal per gram
        let fat     = ((targetCalories * 0.30) / 9).rounded()  // 9 kcal per gram
        let carbs   = ((targetCalories * 0.45) / 4).rounded()  // 4 kcal per gram

        return NutritionMetrics(
            calories: targetCalories,
            protein: protein,
            fat: fat,
            carbs: carbs
        )
    }

    // MARK: - BMR (Mifflin-St Jeor)

    private static func basalMetabolicRate(_ metrics: BodyMetrics) -> Double {
        let w = metrics.weightKg
        let h = metrics.heightCm
        let a = Double(metrics.age)

        switch metrics.sex {
        case .male:
            return 10 * w + 6.25 * h - 5 * a + 5
        case .female:
            return 10 * w + 6.25 * h - 5 * a - 161
        case .notSpecified:
            // Use average of male and female formula
            let male   = 10 * w + 6.25 * h - 5 * a + 5
            let female = 10 * w + 6.25 * h - 5 * a - 161
            return (male + female) / 2
        }
    }

    // MARK: - Unit Conversions

    static func kgToLbs(_ kg: Double) -> Double     { kg * 2.20462 }
    static func lbsToKg(_ lbs: Double) -> Double    { lbs / 2.20462 }
    static func cmToInches(_ cm: Double) -> Double   { cm / 2.54 }
    static func inchesToCm(_ in_: Double) -> Double  { in_ * 2.54 }

    static func cmToFeetInches(_ cm: Double) -> (feet: Int, inches: Int) {
        let totalInches = Int((cm / 2.54).rounded())
        return (totalInches / 12, totalInches % 12)
    }

    static func feetInchesToCm(feet: Int, inches: Int) -> Double {
        Double(feet * 12 + inches) * 2.54
    }
}
