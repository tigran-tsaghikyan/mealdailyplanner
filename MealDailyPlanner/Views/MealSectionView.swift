import SwiftUI

struct MealSectionView: View {
    let meal: Meal
    var familyMembers: [FamilyMember] = []
    /// The meal for the current time of day gets the warm highlight and a "Now" badge.
    var isCurrent: Bool = false

    private var mealIcon: String {
        switch meal.type {
        case .breakfast: return "sunrise"
        case .lunch: return "sun.max"
        case .dinner: return "moon.stars"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row: icon + type + time
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.iconRadius, style: .continuous)
                        .fill(isCurrent ? Palette.accentSoft : Palette.fill)
                        .frame(width: 34, height: 34)
                    Image(systemName: mealIcon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isCurrent ? Palette.accent : Palette.textSecondary)
                }

                Text(meal.type.rawValue)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(Palette.textSecondary)

                if isCurrent {
                    Text("Now")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(Palette.badgeText)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 3)
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Palette.badge))
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10, weight: .semibold))
                    Text("\(meal.prepTimeMinutes) min")
                }
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(isCurrent ? Palette.accentText : Palette.textSecondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(isCurrent ? Palette.accentSoft : Palette.fill))
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.top, 14)

            // Title
            Text(meal.title)
                .font(.system(size: 21, weight: .semibold, design: .rounded))
                .tracking(-0.3)
                .foregroundColor(Palette.text)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.top, 10)
                .padding(.bottom, 12)

            // Ingredient chips
            FlowLayout(spacing: 6) {
                ForEach(meal.ingredients) { ingredient in
                    HStack(spacing: 4) {
                        Text(ingredient.name)
                            .foregroundColor(Palette.text)
                        Text(ingredient.scaled(for: 1.0))
                            .foregroundColor(Palette.textSecondary)
                    }
                    .font(.system(size: 12, design: .rounded))
                    .padding(.horizontal, 11)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(isCurrent ? Palette.chipOnHighlight : Palette.fill))
                }
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.bottom, 14)

            divider

            // Steps
            VStack(alignment: .leading, spacing: 9) {
                ForEach(Array(meal.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(isCurrent ? Palette.accentText : Palette.textSecondary)
                            .frame(width: 20, height: 20)
                            .background(Circle().fill(isCurrent ? Palette.accentSoft : Palette.fill))

                        Text(step)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(Palette.text)
                            .lineSpacing(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.top, 12)
            .padding(.bottom, AppTheme.spacingMD)

            // Packaging (only shown when family has more than 1 member)
            if familyMembers.count > 1 {
                divider
                MealPackagingView(meal: meal, familyMembers: familyMembers)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .softCard(
            isCurrent ? Palette.highlight : Palette.card,
            shadow: isCurrent ? Palette.highlightShadow : Palette.cardShadow,
            shadowRadius: isCurrent ? 12 : 9,
            shadowY: isCurrent ? 8 : 4
        )
    }

    private var divider: some View {
        Rectangle()
            .fill(isCurrent ? Palette.timeline.opacity(0.5) : Palette.divider)
            .frame(height: 1)
    }
}
