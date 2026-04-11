import Foundation

// MARK: - Activity Level

enum ActivityLevel: String, Codable, CaseIterable, Identifiable {
    case sedentary  = "Sedentary"
    case light      = "Light"
    case active     = "Active"
    case veryActive = "Very Active"

    var id: String { rawValue }

    var multiplier: Double {
        switch self {
        case .sedentary:  return 1.2
        case .light:      return 1.375
        case .active:     return 1.55
        case .veryActive: return 1.725
        }
    }

    var description: String {
        switch self {
        case .sedentary:  return "Little or no exercise"
        case .light:      return "Light exercise, 1–3 days/week"
        case .active:     return "Moderate exercise, 3–5 days/week"
        case .veryActive: return "Hard exercise, 6–7 days/week"
        }
    }

    var icon: String {
        switch self {
        case .sedentary:  return "🛋️"
        case .light:      return "🚶"
        case .active:     return "🏃"
        case .veryActive: return "💪"
        }
    }
}

// MARK: - Biological Sex

enum BiologicalSex: String, Codable, CaseIterable, Identifiable {
    case male        = "Male"
    case female      = "Female"
    case notSpecified = "Other"

    var id: String { rawValue }
}

// MARK: - Weight Goal

enum WeightGoal: String, Codable, CaseIterable, Identifiable {
    case loseFat  = "Lose Fat"
    case maintain = "Maintain"
    case gainMass = "Gain Mass"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .loseFat:  return "🔥"
        case .maintain: return "⚖️"
        case .gainMass: return "📈"
        }
    }

    var description: String {
        switch self {
        case .loseFat:  return "Caloric deficit · ~0.5 kg/week loss"
        case .maintain: return "Maintain current body weight"
        case .gainMass: return "Caloric surplus · lean bulk"
        }
    }

    /// Multiplier applied to TDEE to reach the goal
    var tdeeMultiplier: Double {
        switch self {
        case .loseFat:  return 0.80   // –20% deficit
        case .maintain: return 1.00
        case .gainMass: return 1.10   // +10% surplus
        }
    }
}

// MARK: - Body Metrics

struct BodyMetrics: Codable, Hashable {
    var weightKg: Double
    var heightCm: Double
    var age: Int
    var sex: BiologicalSex
    var activityLevel: ActivityLevel
    var goal: WeightGoal
}
