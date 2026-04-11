import SwiftUI

struct MealSectionView: View {
    let meal: Meal
    var familyMembers: [FamilyMember] = []

    private var mealIcon: String {
        switch meal.type {
        case .breakfast: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.stars.fill"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row: icon + type + time
            HStack(spacing: 8) {
                Image(systemName: mealIcon)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.secondary)

                Text(meal.type.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.secondary)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 11))
                    Text("\(meal.prepTimeMinutes) min")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(AppTheme.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(6)
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.top, AppTheme.spacingMD)
            .padding(.bottom, 10)

            // Title
            Text(meal.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppTheme.primary)
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.bottom, 14)

            // Divider
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5)
                .padding(.horizontal, AppTheme.spacingMD)

            // Ingredients
            VStack(spacing: 0) {
                ForEach(Array(meal.ingredients.enumerated()), id: \.element.id) { index, ingredient in
                    HStack {
                        Circle()
                            .fill(Color(.tertiaryLabel))
                            .frame(width: 4, height: 4)
                        Text(ingredient.name)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.primary)
                        Spacer()
                        Text(ingredient.scaled(for: 1.0))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(AppTheme.secondary)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, AppTheme.spacingMD)

                    if index < meal.ingredients.count - 1 {
                        Rectangle()
                            .fill(Color(.separator).opacity(0.5))
                            .frame(height: 0.5)
                            .padding(.leading, 28)
                            .padding(.trailing, AppTheme.spacingMD)
                    }
                }
            }
            .padding(.top, 6)

            // Divider
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5)
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.top, 6)

            // Steps
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(meal.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(.systemBackground))
                            .frame(width: 20, height: 20)
                            .background(AppTheme.primary)
                            .cornerRadius(10)

                        Text(step)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.top, 12)
            .padding(.bottom, AppTheme.spacingMD)

            // Packaging (only shown when family has more than 1 member)
            if familyMembers.count > 1 {
                Rectangle()
                    .fill(Color(.separator))
                    .frame(height: 0.5)
                    .padding(.horizontal, AppTheme.spacingMD)

                MealPackagingView(meal: meal, familyMembers: familyMembers)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}
