import SwiftUI
import WidgetKit

struct LargeMealWidgetView: View {
    let meal: MealData
    let page: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                MealLabel(label: meal.label)
                Spacer()
                PrepTimeLabel(minutes: meal.prepTime)
            }

            Text(meal.title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .tracking(-0.2)
                .foregroundStyle(Palette.text)
                .lineLimit(2)
                .padding(.top, 6)

            section {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(meal.ingredients.prefix(5)) { ingredient in
                        IngredientLine(ingredient: ingredient, size: 12.5)
                    }
                }
            }

            section {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(meal.steps.prefix(3).enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(index + 1)")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundStyle(Palette.accentStrong)
                            Text(step)
                                .font(.system(size: 12, design: .rounded))
                                .foregroundStyle(Palette.text)
                                .lineLimit(2)
                        }
                    }
                }
            }

            Spacer(minLength: 0)

            MealNavigationBar(currentPage: page, compact: false)
        }
    }

    private func section<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(Palette.divider)
                .frame(height: 1)
            content()
                .padding(.top, 12)
        }
        .padding(.top, 12)
    }
}
