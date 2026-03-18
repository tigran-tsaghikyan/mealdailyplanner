import SwiftUI
import WidgetKit

struct LargeMealWidgetView: View {
    let entry: MealWidgetEntry

    var body: some View {
        if entry.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "fork.knife")
                    .font(.largeTitle)
                Text("Set up your plan")
                    .font(.body)
                Text("Open the app to get started")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        } else {
            VStack(alignment: .leading, spacing: 6) {
                // Header
                HStack {
                    Text(entry.mealType.rawValue.uppercased())
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text("\(entry.prepTime) min")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(.secondary)
                }

                Text(entry.mealTitle)
                    .font(.system(size: 17, weight: .bold))
                    .lineLimit(1)

                Divider()

                // Ingredients
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(entry.ingredients) { ingredient in
                        HStack(spacing: 4) {
                            Text(ingredient.name)
                                .font(.system(size: 12))
                                .lineLimit(1)
                            Spacer()
                            Text(ingredient.scaled(for: 1.0))
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Divider()

                // Steps (2-3)
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(Array(entry.steps.prefix(3).enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 4) {
                            Text("\(index + 1).")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                                .frame(width: 16, alignment: .trailing)
                            Text(step)
                                .font(.system(size: 11))
                                .lineLimit(2)
                        }
                    }
                }

                Spacer(minLength: 0)
            }
        }
    }
}
