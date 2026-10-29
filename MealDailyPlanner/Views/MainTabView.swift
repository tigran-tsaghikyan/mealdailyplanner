import SwiftUI

enum AppTab: Hashable {
    case today, profile
}

struct MainTabView: View {
    @StateObject private var dailyPlanVM = DailyPlanViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var subscriptionManager = SubscriptionManager.shared

    @State private var showOnboarding = !StorageManager.shared.hasCompletedOnboarding
    @State private var selectedTab: AppTab = .today

    var body: some View {
        Group {
            if subscriptionManager.canAccessApp {
                // Both tabs stay alive (scroll position, edits) — only the selected one is visible.
                ZStack {
                    tab(.today) {
                        DailyPlanView(
                            viewModel: dailyPlanVM,
                            familyMembers: profileVM.profile.familyMembers,
                            isPro: subscriptionManager.status == .pro
                        )
                    }

                    tab(.profile) {
                        ProfileView(viewModel: profileVM, subscriptionManager: subscriptionManager)
                    }
                }
                .overlay(alignment: .bottom) {
                    FloatingTabBar(selection: $selectedTab)
                        .padding(.bottom, 8)
                }
                .ignoresSafeArea(.keyboard)
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

    private func tab<Content: View>(_ tab: AppTab, @ViewBuilder content: () -> Content) -> some View {
        let isSelected = selectedTab == tab
        return content()
            .opacity(isSelected ? 1 : 0)
            .allowsHitTesting(isSelected)
            .accessibilityHidden(!isSelected)
    }
}

// MARK: - Floating Tab Bar

struct FloatingTabBar: View {
    @Binding var selection: AppTab

    var body: some View {
        HStack(spacing: 4) {
            item(.today, title: "Today", icon: "fork.knife")
            item(.profile, title: "Profile", icon: "person.crop.circle")
        }
        .padding(6)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(Capsule().fill(Palette.card.opacity(0.85)))
                .overlay(Capsule().stroke(Palette.border, lineWidth: 1))
                .shadow(color: Color.black.opacity(0.10), radius: 14, y: 8)
        )
    }

    private func item(_ tab: AppTab, title: String, icon: String) -> some View {
        let isSelected = selection == tab
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                selection = tab
            }
        } label: {
            HStack(spacing: 7) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(title)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .medium, design: .rounded))
            }
            .foregroundColor(isSelected ? Palette.accentText : Palette.textSecondary)
            .padding(.horizontal, 18)
            .padding(.vertical, 9)
            .background(Capsule().fill(isSelected ? Palette.accentSoft : .clear))
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
