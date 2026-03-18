import SwiftUI

struct DailyPlanView: View {
    @ObservedObject var viewModel: DailyPlanViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let plan = viewModel.dailyPlan {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.spacingLG) {
                        // Date
                        Text(plan.formattedDate)
                            .font(AppTheme.headlineFont)
                            .foregroundColor(AppTheme.secondary)
                            .padding(.top, AppTheme.spacingSM)

                        // Meals
                        if let breakfast = plan.breakfast {
                            MealSectionView(meal: breakfast)
                            Divider()
                        }

                        if let lunch = plan.lunch {
                            MealSectionView(meal: lunch)
                            Divider()
                        }

                        if let dinner = plan.dinner {
                            MealSectionView(meal: dinner)
                            Divider()
                        }

                        // Unified Cooking Plan
                        CookingFlowView(
                            cookingFlow: plan.cookingFlow,
                            totalTime: plan.totalCookingTimeMinutes
                        )
                    }
                    .padding(.horizontal, AppTheme.spacingMD)
                    .padding(.bottom, AppTheme.spacingXL)
                }
            } else {
                VStack(spacing: AppTheme.spacingMD) {
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
