import SwiftUI

struct DailyPlanView: View {
    @ObservedObject var viewModel: DailyPlanViewModel
    var familyMembers: [FamilyMember] = []
    var isPro: Bool = false

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let plan = viewModel.dailyPlan {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Date header + refresh button
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(plan.formattedDate)
                                    .font(AppTheme.captionFont)
                                    .foregroundColor(AppTheme.secondary)

                                // Subtle local fallback indicator
                                if viewModel.generatedLocally {
                                    HStack(spacing: 3) {
                                        Image(systemName: "wifi.slash")
                                            .font(.system(size: 9))
                                        Text("Generated locally")
                                            .font(.system(size: 10))
                                    }
                                    .foregroundColor(AppTheme.secondary.opacity(0.6))
                                }
                            }

                            Spacer()

                            if isPro {
                                refreshButton
                            }
                        }
                        .padding(.horizontal, AppTheme.spacingMD)
                        .padding(.top, AppTheme.spacingMD)
                        .padding(.bottom, AppTheme.spacingLG)

                        // Meal cards
                        VStack(spacing: AppTheme.spacingMD) {
                            if let breakfast = plan.breakfast {
                                MealSectionView(meal: breakfast, familyMembers: familyMembers)
                            }
                            if let lunch = plan.lunch {
                                MealSectionView(meal: lunch, familyMembers: familyMembers)
                            }
                            if let dinner = plan.dinner {
                                MealSectionView(meal: dinner, familyMembers: familyMembers)
                            }

                            CookingFlowView(
                                cookingFlow: plan.cookingFlow,
                                totalTime: plan.totalCookingTimeMinutes
                            )
                        }
                        .padding(.horizontal, AppTheme.spacingMD)
                    }
                    .padding(.bottom, AppTheme.spacingXL + 20)
                }
                .background(Color(.secondarySystemBackground))
            } else {
                VStack(spacing: AppTheme.spacingMD) {
                    Image(systemName: "fork.knife.circle")
                        .font(.system(size: 48))
                        .foregroundColor(AppTheme.secondary)
                    Text("No plan yet")
                        .font(AppTheme.titleFont)
                    Text("Set up your profile to get started")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    // MARK: - Refresh Button (Pro only)

    @ViewBuilder
    private var refreshButton: some View {
        if viewModel.canRefresh {
            Button {
                viewModel.refresh()
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 12, weight: .semibold))
                    Text("\(viewModel.remainingRefreshes) left")
                        .font(.system(size: 12, weight: .semibold))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.12))
                .foregroundColor(.green)
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
        } else {
            HStack(spacing: 5) {
                Image(systemName: "clock")
                    .font(.system(size: 12))
                Text("Resets at midnight")
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(.tertiarySystemFill))
            .foregroundColor(AppTheme.secondary)
            .cornerRadius(8)
        }
    }
}
