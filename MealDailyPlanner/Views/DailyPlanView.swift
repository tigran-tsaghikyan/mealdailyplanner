import SwiftUI

struct DailyPlanView: View {
    @ObservedObject var viewModel: DailyPlanViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let plan = viewModel.dailyPlan {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Date header
                        Text(plan.formattedDate)
                            .font(AppTheme.captionFont)
                            .foregroundColor(AppTheme.secondary)
                            .padding(.horizontal, AppTheme.spacingMD)
                            .padding(.top, AppTheme.spacingMD)
                            .padding(.bottom, AppTheme.spacingLG)

                        // Meal cards
                        VStack(spacing: AppTheme.spacingMD) {
                            if let breakfast = plan.breakfast {
                                MealSectionView(meal: breakfast)
                            }
                            if let lunch = plan.lunch {
                                MealSectionView(meal: lunch)
                            }
                            if let dinner = plan.dinner {
                                MealSectionView(meal: dinner)
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
}
