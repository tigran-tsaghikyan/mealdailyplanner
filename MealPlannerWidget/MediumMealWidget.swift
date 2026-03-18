import SwiftUI
import WidgetKit

struct MediumMealWidgetView: View {
    let meal: MealData
    let page: Int

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(meal.label)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.gray)

                    Text(meal.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color(.label))
                        .lineLimit(2)

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text("\(meal.prepTime) min")
                            .font(.system(size: 11))
                    }
                    .foregroundStyle(Color.gray)
                }

                Divider()

                VStack(alignment: .leading, spacing: 3) {
                    ForEach(meal.ingredients.prefix(3)) { ingredient in
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
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }

            PageDots(currentPage: page)
                .padding(.top, 4)
        }
    }
}
