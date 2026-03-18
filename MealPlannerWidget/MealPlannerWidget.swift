import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Configuration Intent

struct MealTypeIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Meal"
    static var description: IntentDescription = "Choose which meal to display"

    @Parameter(title: "Meal Type", default: .breakfast)
    var mealType: MealTypeOption
}

enum MealTypeOption: String, AppEnum {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Meal Type")
    static var caseDisplayRepresentations: [MealTypeOption: DisplayRepresentation] = [
        .breakfast: "Breakfast",
        .lunch: "Lunch",
        .dinner: "Dinner"
    ]
}

// MARK: - Timeline Entry

struct MealWidgetEntry: TimelineEntry {
    let date: Date
    let mealType: MealTypeOption
    let mealTitle: String
    let ingredients: [MealIngredient]
    let steps: [String]
    let prepTime: Int
    let isEmpty: Bool
}

// MARK: - Timeline Provider

struct MealTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MealWidgetEntry {
        MealWidgetEntry(
            date: Date(),
            mealType: .breakfast,
            mealTitle: "Scrambled Eggs with Toast",
            ingredients: [
                MealIngredient(name: "Eggs", baseGrams: 4, unit: "pcs"),
                MealIngredient(name: "Bread", baseGrams: 4, unit: "slices"),
            ],
            steps: ["Whisk eggs", "Cook in butter", "Toast bread"],
            prepTime: 7,
            isEmpty: false
        )
    }

    func snapshot(for configuration: MealTypeIntent, in context: Context) async -> MealWidgetEntry {
        loadEntry(for: configuration)
    }

    func timeline(for configuration: MealTypeIntent, in context: Context) async -> Timeline<MealWidgetEntry> {
        let entry = loadEntry(for: configuration)

        // Refresh at midnight
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date())
        return Timeline(entries: [entry], policy: .after(tomorrow))
    }

    private func loadEntry(for configuration: MealTypeIntent) -> MealWidgetEntry {
        let defaults = UserDefaults(suiteName: "group.com.mealdailyplanner.app")
        guard let data = defaults?.data(forKey: "dailyPlan"),
              let plan = try? JSONDecoder().decode(DailyPlan.self, from: data) else {
            return MealWidgetEntry(
                date: Date(),
                mealType: configuration.mealType,
                mealTitle: "",
                ingredients: [],
                steps: [],
                prepTime: 0,
                isEmpty: true
            )
        }

        let meal: Meal?
        switch configuration.mealType {
        case .breakfast: meal = plan.breakfast
        case .lunch: meal = plan.lunch
        case .dinner: meal = plan.dinner
        }

        guard let m = meal else {
            return MealWidgetEntry(
                date: Date(),
                mealType: configuration.mealType,
                mealTitle: "",
                ingredients: [],
                steps: [],
                prepTime: 0,
                isEmpty: true
            )
        }

        return MealWidgetEntry(
            date: plan.date,
            mealType: configuration.mealType,
            mealTitle: m.title,
            ingredients: m.ingredients,
            steps: m.steps,
            prepTime: m.prepTimeMinutes,
            isEmpty: false
        )
    }
}

// MARK: - Widget View (size-adaptive)

struct MealWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: MealWidgetEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallMealWidgetView(entry: entry)
        case .systemMedium:
            MediumMealWidgetView(entry: entry)
        case .systemLarge:
            LargeMealWidgetView(entry: entry)
        default:
            SmallMealWidgetView(entry: entry)
        }
    }
}

// MARK: - Widget Definition

struct MealPlannerWidget: Widget {
    let kind = "MealPlannerWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: MealTypeIntent.self,
            provider: MealTimelineProvider()
        ) { entry in
            MealWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Meal Planner")
        .description("View your daily meal plan")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
