import SwiftUI
import WidgetKit

struct SmallMealWidgetView: View {
    let meal: MealData
    let page: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MealLabel(label: meal.label)

            Text(meal.title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Palette.text)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 6)

            Spacer(minLength: 4)

            PrepTimeLabel(minutes: meal.prepTime)

            MealNavigationBar(currentPage: page, compact: true)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
