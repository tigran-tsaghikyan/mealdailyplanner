import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Navigation Intents

struct NextMealIntent: AppIntent {
    static var title: LocalizedStringResource = "Next Meal"
    static var description: IntentDescription = "Show the next meal"

    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "group.com.mealdailyplanner.app")
        let current = defaults?.integer(forKey: "widgetPage") ?? 0
        let next = (current + 1) % 3
        defaults?.set(next, forKey: "widgetPage")
        defaults?.synchronize()
        return .result()
    }
}

struct PreviousMealIntent: AppIntent {
    static var title: LocalizedStringResource = "Previous Meal"
    static var description: IntentDescription = "Show the previous meal"

    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "group.com.mealdailyplanner.app")
        let current = defaults?.integer(forKey: "widgetPage") ?? 0
        let prev = (current + 2) % 3 // +2 mod 3 == -1 mod 3
        defaults?.set(prev, forKey: "widgetPage")
        defaults?.synchronize()
        return .result()
    }
}

// MARK: - Timeline Entry

struct MealWidgetEntry: TimelineEntry {
    let date: Date
    let currentPage: Int // 0=breakfast, 1=lunch, 2=dinner
    let meals: [MealData] // always 3
    let isEmpty: Bool
}

struct MealData {
    let label: String
    let title: String
    let ingredients: [MealIngredient]
    let steps: [String]
    let prepTime: Int
}

// MARK: - Timeline Provider

struct MealTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> MealWidgetEntry {
        MealWidgetEntry(
            date: Date(),
            currentPage: 0,
            meals: [
                MealData(label: "Breakfast", title: "Scrambled Eggs", ingredients: [], steps: [], prepTime: 7),
                MealData(label: "Lunch", title: "Chicken Rice Bowl", ingredients: [], steps: [], prepTime: 12),
                MealData(label: "Dinner", title: "Salmon with Greens", ingredients: [], steps: [], prepTime: 15),
            ],
            isEmpty: false
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (MealWidgetEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MealWidgetEntry>) -> Void) {
        let entry = loadEntry()
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date())
        completion(Timeline(entries: [entry], policy: .after(tomorrow)))
    }

    private func loadEntry() -> MealWidgetEntry {
        let defaults = UserDefaults(suiteName: "group.com.mealdailyplanner.app")

        // Use manually selected page if set, otherwise default to time-based
        let page: Int
        if defaults?.object(forKey: "widgetPage") != nil {
            page = defaults?.integer(forKey: "widgetPage") ?? 0
        } else {
            page = mealPageForCurrentTime()
        }

        guard let data = defaults?.data(forKey: "dailyPlan"),
              let plan = try? JSONDecoder().decode(DailyPlan.self, from: data) else {
            return MealWidgetEntry(
                date: Date(),
                currentPage: page,
                meals: [
                    MealData(label: "Breakfast", title: "", ingredients: [], steps: [], prepTime: 0),
                    MealData(label: "Lunch", title: "", ingredients: [], steps: [], prepTime: 0),
                    MealData(label: "Dinner", title: "", ingredients: [], steps: [], prepTime: 0),
                ],
                isEmpty: true
            )
        }

        let meals = [plan.breakfast, plan.lunch, plan.dinner].enumerated().map { index, meal -> MealData in
            let labels = ["Breakfast", "Lunch", "Dinner"]
            guard let m = meal else {
                return MealData(label: labels[index], title: "", ingredients: [], steps: [], prepTime: 0)
            }
            return MealData(
                label: labels[index],
                title: m.title,
                ingredients: m.ingredients,
                steps: m.steps,
                prepTime: m.prepTimeMinutes
            )
        }

        return MealWidgetEntry(
            date: plan.date,
            currentPage: page,
            meals: meals,
            isEmpty: false
        )
    }

    private func mealPageForCurrentTime() -> Int {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return 0 }
        if hour < 18 { return 1 }
        return 2
    }
}

// MARK: - Navigation Arrows

struct MealNavigationBar: View {
    let currentPage: Int
    let compact: Bool

    var body: some View {
        HStack(spacing: 0) {
            Button(intent: PreviousMealIntent()) {
                Image(systemName: "chevron.left")
                    .font(.system(size: compact ? 11 : 12, weight: .bold))
                    .foregroundStyle(Palette.textSecondary)
                    .frame(width: compact ? 24 : 30, height: compact ? 24 : 30)
                    .background(Circle().fill(Palette.fill))
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Palette.accent : Palette.dotInactive)
                        .frame(width: 6, height: 6)
                }
            }

            Spacer()

            Button(intent: NextMealIntent()) {
                Image(systemName: "chevron.right")
                    .font(.system(size: compact ? 11 : 12, weight: .bold))
                    .foregroundStyle(Palette.textSecondary)
                    .frame(width: compact ? 24 : 30, height: compact ? 24 : 30)
                    .background(Circle().fill(Palette.fill))
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Shared Pieces

struct MealLabel: View {
    let label: String

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(Palette.accent)
                .frame(width: 6, height: 6)
            Text(label)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(Palette.accentStrong)
        }
    }
}

struct PrepTimeLabel: View {
    let minutes: Int

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
                .font(.system(size: 10, weight: .semibold))
            Text("\(minutes) min")
                .font(.system(size: 11, weight: .medium, design: .rounded))
        }
        .foregroundStyle(Palette.textSecondary)
    }
}

struct IngredientLine: View {
    let ingredient: MealIngredient
    var size: CGFloat = 12

    var body: some View {
        HStack(spacing: 4) {
            Text(ingredient.name)
                .foregroundStyle(Palette.text)
                .lineLimit(1)
            Spacer(minLength: 4)
            Text(ingredient.scaled(for: 1.0))
                .foregroundStyle(Palette.textSecondary)
        }
        .font(.system(size: size, design: .rounded))
    }
}

// MARK: - Widget View (size-adaptive)

struct MealWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: MealWidgetEntry

    var currentMeal: MealData {
        entry.meals[entry.currentPage]
    }

    var body: some View {
        if entry.isEmpty {
            emptyState
        } else {
            switch family {
            case .systemSmall:
                SmallMealWidgetView(meal: currentMeal, page: entry.currentPage)
            case .systemMedium:
                MediumMealWidgetView(meal: currentMeal, page: entry.currentPage)
            case .systemLarge:
                LargeMealWidgetView(meal: currentMeal, page: entry.currentPage)
            default:
                SmallMealWidgetView(meal: currentMeal, page: entry.currentPage)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "fork.knife")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Palette.accent)
            Text("Set up your plan")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Palette.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Widget Definition

struct MealPlannerWidget: Widget {
    let kind = "MealPlannerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MealTimelineProvider()) { entry in
            MealWidgetView(entry: entry)
                .containerBackground(Palette.card, for: .widget)
        }
        .configurationDisplayName("Meal Planner")
        .description("Shows your daily meals — tap arrows to switch")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
