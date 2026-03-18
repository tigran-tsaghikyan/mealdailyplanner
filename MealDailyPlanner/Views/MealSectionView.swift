import SwiftUI

struct MealSectionView: View {
    let meal: Meal

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
            // Meal type header
            Text(meal.type.rawValue.uppercased())
                .font(AppTheme.largeTitleFont)
                .foregroundColor(AppTheme.primary)

            // Title
            Text(meal.title)
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.secondary)

            // Prep time
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.caption)
                Text("\(meal.prepTimeMinutes) min")
                    .font(AppTheme.captionFont)
            }
            .foregroundColor(AppTheme.secondary)

            // Ingredients
            VStack(alignment: .leading, spacing: AppTheme.spacingXS) {
                ForEach(meal.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                            .font(AppTheme.bodyFont)
                        Spacer()
                        Text(ingredient.scaled(for: 1.0))
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.secondary)
                    }
                }
            }
            .padding(.top, AppTheme.spacingXS)

            // Steps
            VStack(alignment: .leading, spacing: AppTheme.spacingXS) {
                ForEach(Array(meal.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: AppTheme.spacingSM) {
                        Text("\(index + 1).")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.secondary)
                            .frame(width: 20, alignment: .trailing)
                        Text(step)
                            .font(AppTheme.bodyFont)
                    }
                }
            }
            .padding(.top, AppTheme.spacingXS)
        }
        .padding(.vertical, AppTheme.spacingSM)
    }
}
