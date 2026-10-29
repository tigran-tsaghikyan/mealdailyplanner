import SwiftUI

struct DailyPlanView: View {
    @ObservedObject var viewModel: DailyPlanViewModel
    var familyMembers: [FamilyMember] = []
    var isPro: Bool = false

    private var servings: Double {
        familyMembers.reduce(0) { $0 + $1.scalingFactor }
    }

    /// Breakfast before noon, lunch until 6 pm, dinner after (matches the widget).
    private var currentMealType: MealType {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return .breakfast }
        if hour < 18 { return .lunch }
        return .dinner
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let plan = viewModel.dailyPlan {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        header(plan)

                        statsRow(plan)
                            .padding(.top, 16)
                            .padding(.bottom, 20)

                        VStack(spacing: 14) {
                            ForEach([plan.breakfast, plan.lunch, plan.dinner].compactMap { $0 }) { meal in
                                MealSectionView(
                                    meal: meal,
                                    familyMembers: familyMembers,
                                    isCurrent: Calendar.current.isDateInToday(plan.date) && meal.type == currentMealType
                                )
                            }

                            CookingFlowView(
                                cookingFlow: plan.cookingFlow,
                                totalTime: plan.totalCookingTimeMinutes
                            )
                        }
                    }
                    .padding(.horizontal, AppTheme.spacingMD)
                    .padding(.top, 8)
                    .padding(.bottom, 110)
                }
            } else {
                VStack(spacing: AppTheme.spacingMD) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Palette.accentSoft)
                            .frame(width: 76, height: 76)
                        Image(systemName: "fork.knife")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(Palette.accent)
                    }
                    Text("No plan yet")
                        .font(AppTheme.titleFont)
                        .foregroundColor(Palette.text)
                    Text("Set up your profile to get started")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(Palette.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .statusBarScrim()
        .background(Palette.background.ignoresSafeArea())
    }

    // MARK: - Header

    private func header(_ plan: DailyPlan) -> some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Today")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tracking(-0.5)
                    .foregroundColor(Palette.text)
                Text(plan.formattedDate)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(Palette.textSecondary)

                // Subtle local fallback indicator
                if viewModel.generatedLocally {
                    HStack(spacing: 3) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 9))
                        Text("Generated locally")
                            .font(.system(size: 10, design: .rounded))
                    }
                    .foregroundColor(Palette.textTertiary)
                    .padding(.top, 2)
                }
            }

            Spacer()

            HStack(spacing: 6) {
                if isPro {
                    refreshButton
                }
                if servings > 0 {
                    pill {
                        Image(systemName: "person")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Palette.accent)
                        Text("Serves \(Self.formatServings(servings))")
                            .foregroundColor(Palette.text)
                    }
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.top, 8)
    }

    private func pill<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        HStack(spacing: 6, content: content)
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(Palette.card))
            .overlay(Capsule().stroke(Palette.border, lineWidth: 1))
    }

    static func formatServings(_ value: Double) -> String {
        value == value.rounded() ? String(Int(value)) : String(format: "%.1f", value)
    }

    // MARK: - Stats

    private func statsRow(_ plan: DailyPlan) -> some View {
        let ingredientCount = Set(plan.meals.flatMap { $0.ingredients.map { $0.name.lowercased() } }).count
        return HStack(spacing: 8) {
            statTile(value: "\(plan.meals.count)", label: "meals")
            statTile(value: "\(plan.totalCookingTimeMinutes) min", label: "total cooking", valueColor: Palette.accentStrong)
            statTile(value: "\(ingredientCount)", label: "ingredients")
        }
    }

    private func statTile(value: String, label: String, valueColor: Color = Palette.text) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(value)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(valueColor)
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(Palette.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .softCard(radius: AppTheme.tileRadius)
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
                        .font(.system(size: 11, weight: .semibold))
                    Text("\(viewModel.remainingRefreshes) left")
                }
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(Palette.accentText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(Palette.accentSoft))
            }
            .buttonStyle(.plain)
        } else {
            HStack(spacing: 5) {
                Image(systemName: "clock")
                    .font(.system(size: 11))
                Text("Resets at midnight")
            }
            .font(.system(size: 12, design: .rounded))
            .foregroundColor(Palette.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(Palette.fill))
        }
    }
}
