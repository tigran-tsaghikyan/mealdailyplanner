import SwiftUI
import WidgetKit

struct SmallMealWidgetView: View {
    let entry: MealWidgetEntry

    var body: some View {
        if entry.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "fork.knife")
                    .font(.title2)
                Text("Set up your plan")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(.secondary)
        } else {
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.mealType.rawValue.uppercased())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)

                Text(entry.mealTitle)
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
