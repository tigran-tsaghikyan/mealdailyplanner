import SwiftUI
import WidgetKit

struct LargeMealWidgetView: View {
    let meal: MealData
    let page: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(meal.label)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.gray)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                    Text("\(meal.prepTime) min")
                        .font(.system(size: 11))
                }
                .foregroundStyle(Color.gray)
            }

            Text(meal.title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(.label))
                .lineLimit(1)

            Divider()

            VStack(alignment: .leading, spacing: 2) {
                ForEach(meal.ingredients) { ingredient in
                    HStack(spacing: 4) {
                        Text(ingredient.name)
                            .font(.system(size: 12))
                            .foregroundStyle(Color(.label))
                            .lineLimit(1)
                        Spacer()
                        Text(ingredient.scaled(for: 1.0))
                            .font(.system(size: 11))
                            .foregroundStyle(Color.gray)
                    }
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 3) {
                ForEach(Array(meal.steps.prefix(3).enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 4) {
                        Text("\(index + 1).")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.gray)
                            .frame(width: 16, alignment: .trailing)
                        Text(step)
                            .font(.system(size: 11))
                            .foregroundStyle(Color(.label))
                            .lineLimit(2)
                    }
                }
            }

            Spacer(minLength: 0)

            MealNavigationBar(currentPage: page, compact: false)
        }
    }
}
