import SwiftUI
import WidgetKit

struct MediumMealWidgetView: View {
    let meal: MealData
    let page: Int

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 0) {
                    MealLabel(label: meal.label)

                    Text(meal.title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(Palette.text)
                        .lineLimit(3)
                        .padding(.top, 6)

                    Spacer(minLength: 4)

                    PrepTimeLabel(minutes: meal.prepTime)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Rectangle()
                    .fill(Palette.divider)
                    .frame(width: 1)

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(meal.ingredients.prefix(3)) { ingredient in
                        IngredientLine(ingredient: ingredient)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top, 2)
                .frame(maxWidth: .infinity)
            }

            MealNavigationBar(currentPage: page, compact: false)
                .padding(.top, 10)
        }
    }
}
