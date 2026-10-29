import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject var subscriptionManager: SubscriptionManager
    @State private var showPaywall = false
    @AppStorage(AppearanceMode.storageKey) private var appearance: AppearanceMode = .auto

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Profile")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tracking(-0.5)
                    .foregroundColor(Palette.text)
                    .padding(.horizontal, 4)
                    .padding(.top, 8)
                    .padding(.bottom, -4)

                // MARK: - Plan Status
                PlanStatusCard(subscriptionManager: subscriptionManager)
                    .onTapGesture {
                        if subscriptionManager.status != .pro {
                            showPaywall = true
                        }
                    }

                familySection
                allergiesSection
                ingredientsSection
                preferencesSection
                appearanceSection
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.top, 8)
            .padding(.bottom, 110)
        }
        .scrollDismissesKeyboard(.interactively)
        .statusBarScrim()
        .background(Palette.background.ignoresSafeArea())
        .sheet(isPresented: $showPaywall) {
            NavigationStack {
                PaywallView(subscriptionManager: subscriptionManager)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") { showPaywall = false }
                        }
                    }
            }
        }
    }

    // MARK: - Family Members

    private var familySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(spacing: 0) {
                ForEach(viewModel.profile.familyMembers) { member in
                    FamilyMemberRow(
                        member: member,
                        onSetChild: { isChild in
                            if member.isChild != isChild { viewModel.toggleChildStatus(for: member) }
                        },
                        onRename: { viewModel.renameMember(member, to: $0) },
                        onUpdateNutrition: { nutrition, bodyMetrics in
                            viewModel.updateNutritionTargets(for: member, nutrition: nutrition, bodyMetrics: bodyMetrics)
                        },
                        onClearNutrition: { viewModel.clearNutritionTargets(for: member) },
                        onDelete: viewModel.canRemoveMember ? { viewModel.removeMember(member) } : nil
                    )
                    rowDivider
                }

                IngredientInputView(
                    placeholder: "Member name",
                    text: $viewModel.newMemberName,
                    onAdd: viewModel.addMember,
                    isDisabled: !viewModel.canAddMember
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .softCard()

            HStack(spacing: 0) {
                Text("Cooking for ")
                Text("\(DailyPlanView.formatServings(viewModel.profile.scalingMultiplier)) portions")
                    .fontWeight(.semibold)
                    .foregroundColor(Palette.accentStrong)
                Text(" — adults ×1.0, children ×0.5")
            }
            .font(.system(size: 12, design: .rounded))
            .foregroundColor(Palette.textSecondary)
            .padding(.horizontal, 4)
        }
        .sectionHeader("Family", trailing: "\(viewModel.familySize) of \(ProfileViewModel.maxFamilyMembers)")
    }

    // MARK: - Allergies

    private var allergiesSection: some View {
        chipCard(
            items: viewModel.profile.allergies,
            emptyText: "No allergies added",
            onRemove: viewModel.removeAllergy,
            input: IngredientInputView(
                placeholder: "Add allergy (e.g. peanuts)",
                text: $viewModel.newAllergyText,
                onAdd: viewModel.addAllergy,
                isDisabled: !viewModel.canAddAllergy
            )
        )
        .sectionHeader("Allergies", trailing: "\(viewModel.profile.allergies.count) of \(ProfileViewModel.maxAllergies)")
    }

    // MARK: - Available Ingredients

    private var ingredientsSection: some View {
        chipCard(
            items: viewModel.profile.availableIngredients,
            emptyText: "Nothing added — all recipes available",
            onRemove: viewModel.removeIngredient,
            input: IngredientInputView(
                placeholder: "Add ingredient (e.g. chicken)",
                text: $viewModel.newIngredientText,
                onAdd: viewModel.addIngredient,
                isDisabled: !viewModel.canAddIngredient
            )
        )
        .sectionHeader("Available ingredients", trailing: "\(viewModel.profile.availableIngredients.count) of \(ProfileViewModel.maxIngredients)")
    }

    private func chipCard(
        items: [String],
        emptyText: String,
        onRemove: @escaping (String) -> Void,
        input: IngredientInputView
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if items.isEmpty {
                Text(emptyText)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(Palette.textSecondary)
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        RemovableChip(title: item) { onRemove(item) }
                    }
                }
            }

            Rectangle()
                .fill(Palette.divider)
                .frame(height: 1)

            input
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .softCard()
    }

    // MARK: - Meal Preferences

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                if viewModel.mealPreferencesText.isEmpty {
                    Text("e.g. We prefer Mediterranean food, quick meals, no spicy dishes…")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Palette.textTertiary)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $viewModel.mealPreferencesText)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(Palette.text)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 80)
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 6)
            .softCard()

            Text("Sent to AI to personalise your daily meal plan.")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Palette.textSecondary)
                .padding(.horizontal, 4)
        }
        .sectionHeader("Meal preferences")
    }

    // MARK: - Appearance

    private var appearanceSection: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.iconRadius, style: .continuous)
                    .fill(Palette.accentSoft)
                    .frame(width: 34, height: 34)
                Image(systemName: "circle.lefthalf.filled")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Palette.accent)
            }

            VStack(alignment: .leading, spacing: 1) {
                Text("Theme")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(Palette.text)
                Text("Follows system")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(Palette.textSecondary)
            }

            Spacer(minLength: 4)

            PillSegment(
                options: AppearanceMode.allCases.map {
                    .init(value: $0, title: $0.title, icon: $0.icon, selectedText: Palette.accentStrong)
                },
                selection: appearance,
                onSelect: { appearance = $0 }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .softCard()
        .sectionHeader("Appearance")
    }

    private var rowDivider: some View {
        Rectangle()
            .fill(Palette.divider)
            .frame(height: 1)
    }
}

// MARK: - Removable Chip

struct RemovableChip: View {
    let title: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 7) {
            Text(title)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(Palette.text)
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Palette.textSecondary)
                    .frame(width: 16, height: 16)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove \(title)")
        }
        .padding(.leading, 12)
        .padding(.trailing, 8)
        .padding(.vertical, 7)
        .background(Capsule().fill(Palette.fill))
    }
}

// MARK: - Plan Status Card

struct PlanStatusCard: View {
    @ObservedObject var subscriptionManager: SubscriptionManager

    private var isPro: Bool { subscriptionManager.status == .pro }

    var body: some View {
        HStack(spacing: 13) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Palette.accentSoft)
                    .frame(width: 44, height: 44)

                Image(systemName: isPro ? "crown" : "clock")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Palette.accent)
            }

            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text(subscriptionManager.status.rawValue)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Palette.text)

                Group {
                    switch subscriptionManager.status {
                    case .free:
                        Text(subscriptionManager.trialRemainingText)
                    case .expired:
                        Text("Subscribe to continue")
                    case .pro:
                        Text(subscriptionManager.subscriptionExpirationText ?? "Active subscription")
                    }
                }
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(Palette.textSecondary)
            }

            Spacer()

            // Badge
            if isPro {
                Text("Pro")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(Palette.badgeText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Palette.badge))
            } else {
                if subscriptionManager.status == .free {
                    // Trial progress ring
                    ZStack {
                        Circle()
                            .stroke(Palette.accentSoft, lineWidth: 3)
                        Circle()
                            .trim(from: 0, to: trialProgress)
                            .stroke(Palette.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                    }
                    .frame(width: 30, height: 30)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Palette.textTertiary)
            }
        }
        .padding(16)
        .softCard()
        .contentShape(Rectangle())
    }

    private var trialProgress: CGFloat {
        let total = subscriptionManager.trialEndDate.timeIntervalSince(subscriptionManager.trialStartDate)
        let elapsed = Date().timeIntervalSince(subscriptionManager.trialStartDate)
        guard total > 0 else { return 0 }
        return CGFloat(max(0, min(1, 1 - (elapsed / total))))
    }
}
