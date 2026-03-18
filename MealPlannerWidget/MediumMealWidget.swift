import SwiftUI
import WidgetKit

struct MediumMealWidgetView: View {
    let entry: MealWidgetEntry

    var body: some View {
        if entry.isEmpty {
            HStack {
                VStack(spacing: 8) {
                    Image(systemName: "fork.knife")
                        .font(.title2)
                    Text("Set up your plan")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
            }
        } else {
            HStack(spacing: 12) {
                // Left: meal info
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.mealType.rawValue.uppercased())
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)

                    Text(entry.mealTitle)
                        .font(.system(size: 15, weight: .bold))
                        .lineLimit(2)

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text("\(entry.prepTime) min")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(.secondary)
                }

                Divider()

                // Right: key ingredients
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(entry.ingredients.prefix(3)) { ingredient in
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
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
