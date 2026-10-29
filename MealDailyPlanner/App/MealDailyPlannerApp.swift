import SwiftUI

@main
struct MealDailyPlannerApp: App {
    @AppStorage(AppearanceMode.storageKey) private var appearance: AppearanceMode = .auto

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .fontDesign(.rounded)
                .tint(Palette.accentStrong)
                .preferredColorScheme(appearance.colorScheme)
        }
    }
}
