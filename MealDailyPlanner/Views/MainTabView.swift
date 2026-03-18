import SwiftUI

struct MainTabView: View {
    @StateObject private var dailyPlanVM = DailyPlanViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var subscriptionManager = SubscriptionManager.shared

    var body: some View {
        Group {
            if subscriptionManager.canAccessApp {
                TabView {
                    DailyPlanView(viewModel: dailyPlanVM)
                        .tabItem {
                            Image(systemName: "fork.knife")
                            Text("Today")
                        }

                    NavigationStack {
                        ProfileView(viewModel: profileVM, subscriptionManager: subscriptionManager)
                            .navigationTitle("Profile")
                    }
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
                }
                .tint(AppTheme.primary)
            } else {
                PaywallView(subscriptionManager: subscriptionManager)
            }
        }
        .task {
            await subscriptionManager.loadProducts()
            await subscriptionManager.checkStatus()
        }
    }
}
