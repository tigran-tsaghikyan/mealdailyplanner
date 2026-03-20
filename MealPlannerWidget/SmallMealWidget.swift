import SwiftUI
import WidgetKit

struct SmallMealWidgetView: View {
    let meal: MealData
    let page: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(meal.label)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.gray)

            Text(meal.title)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color(.label))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.system(size: 10))
                Text("\(meal.prepTime) min")
                    .font(.system(size: 11))
            }
            .foregroundStyle(Color.gray)

            MealNavigationBar(currentPage: page, compact: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
