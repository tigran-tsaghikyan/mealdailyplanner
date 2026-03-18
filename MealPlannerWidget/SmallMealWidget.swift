import SwiftUI
import WidgetKit

struct SmallMealWidgetView: View {
    let meal: MealData
    let page: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(meal.label)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.gray)

            Text(meal.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color(.label))
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            HStack {
                Spacer()
                PageDots(currentPage: page)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
