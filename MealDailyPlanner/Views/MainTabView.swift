import SwiftUI

struct MainTabView: View {
    @StateObject private var dailyPlanVM = DailyPlanViewModel()
    @StateObject private var profileVM = ProfileViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                DailyPlanView(viewModel: dailyPlanVM)
                    .navigationTitle("Today")
            }
            .tabItem {
                Image(systemName: "fork.knife")
                Text("Today")
            }

            NavigationStack {
                ProfileView(viewModel: profileVM)
                    .navigationTitle("Profile")
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Profile")
            }
        }
        .tint(AppTheme.primary)
    }
}
