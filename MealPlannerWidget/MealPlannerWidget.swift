import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Page Navigation Intent

struct CycleMealPageIntent: AppIntent {
    static var title: LocalizedStringResource = "Next Meal"
    static var description: IntentDescription = "Show the next meal"

    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "group.com.mealdailyplanner.app")
        let current = defaults?.integer(forKey: "widgetPage") ?? 0
        let next = (current + 1) % 3
        defaults?.set(next, forKey: "widgetPage")
        WidgetCenter.shared.reloadTimelines(ofKind: "MealPlannerWidget")
        return .result()
    }
}

struct GoToPageIntent: AppIntent {
    static var title: LocalizedStringResource = "Go To Meal"
    static var description: IntentDescription = "Show a specific meal"

    @Parameter(title: "Page")
    var page: Int

    init() { self.page = 0 }
    init(page: Int) { self.page = page }

    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "group.com.mealdailyplanner.app")
        defaults?.set(page, forKey: "widgetPage")
        WidgetCenter.shared.reloadTimelines(ofKind: "MealPlannerWidget")
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
        let page = defaults?.integer(forKey: "widgetPage") ?? 0

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
}

// MARK: - Page Dots

struct PageDots: View {
    let currentPage: Int
    let totalPages: Int = 3

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalPages, id: \.self) { index in
                Button(intent: GoToPageIntent(page: index)) {
                    Circle()
                        .fill(index == currentPage ? Color(.label) : Color.gray.opacity(0.4))
                        .frame(width: 6, height: 6)
                }
                .buttonStyle(.plain)
            }
        }
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
            Button(intent: CycleMealPageIntent()) {
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
            .buttonStyle(.plain)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "fork.knife")
                .font(.title2)
                .foregroundStyle(Color.gray)
            Text("Set up your plan")
                .font(.caption)
                .foregroundStyle(Color.gray)
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
                .containerBackground(Color(.systemBackground), for: .widget)
        }
        .configurationDisplayName("Meal Planner")
        .description("Tap to cycle through breakfast, lunch, dinner")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
