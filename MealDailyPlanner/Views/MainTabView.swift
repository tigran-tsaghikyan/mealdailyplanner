import SwiftUI

struct MainTabView: View {
    @StateObject private var dailyPlanVM = DailyPlanViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var subscriptionManager = SubscriptionManager.shared

    @State private var showOnboarding = !StorageManager.shared.hasCompletedOnboarding

    var body: some View {
        Group {
            if subscriptionManager.canAccessApp {
                TabView {
                    DailyPlanView(
                        viewModel: dailyPlanVM,
                        familyMembers: profileVM.profile.familyMembers,
                        isPro: subscriptionManager.status == .pro
                    )
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
                .fullScreenCover(isPresented: $showOnboarding) {
                    OnboardingView {
                        // Reload profile & generate plan after onboarding completes
                        profileVM.reload()
                        dailyPlanVM.generateForce()
                        showOnboarding = false
                    }
                }
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
