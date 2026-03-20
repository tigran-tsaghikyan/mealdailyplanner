import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject var subscriptionManager: SubscriptionManager
    @State private var showPaywall = false

    var body: some View {
        List {
            // MARK: - Plan Status
            Section {
                PlanStatusCard(subscriptionManager: subscriptionManager)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        if subscriptionManager.status != .pro {
                            showPaywall = true
                        }
                    }
            }

            // MARK: - Family Members
            Section {
                ForEach(viewModel.profile.familyMembers) { member in
                    FamilyMemberRow(
                        member: member,
                        onToggle: { viewModel.toggleChildStatus(for: member) },
                        onRename: { viewModel.renameMember(member, to: $0) }
                    )
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        if viewModel.canRemoveMember {
                            Button(role: .destructive) {
                                viewModel.removeMember(member)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }

                IngredientInputView(
                    placeholder: "Member name",
                    text: $viewModel.newMemberName,
                    onAdd: viewModel.addMember,
                    isDisabled: !viewModel.canAddMember
                )
            } header: {
                HStack {
                    Text("Family Members")
                    Spacer()
                    Text("\(viewModel.familySize)/\(ProfileViewModel.maxFamilyMembers)")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.secondary)
                    ScalingInfoView(profile: viewModel.profile)
                }
            }

            // MARK: - Allergies
            Section {
                if viewModel.profile.allergies.isEmpty {
                    Text("No allergies added")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.secondary)
                } else {
                    ForEach(Array(viewModel.profile.allergies.enumerated()), id: \.offset) { index, allergy in
                        EditableTextRow(
                            text: allergy,
                            onSave: { viewModel.editAllergy(allergy, to: $0) }
                        )
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.removeAllergy(allergy)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }

                IngredientInputView(
                    placeholder: "Add allergy (e.g. peanuts)",
                    text: $viewModel.newAllergyText,
                    onAdd: viewModel.addAllergy,
                    isDisabled: !viewModel.canAddAllergy
                )
            } header: {
                HStack {
                    Text("Allergies")
                    Spacer()
                    Text("\(viewModel.profile.allergies.count)/\(ProfileViewModel.maxAllergies)")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.secondary)
                }
            }

            // MARK: - Available Ingredients
            Section {
                if viewModel.profile.availableIngredients.isEmpty {
                    Text("No ingredients added — all recipes available")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.secondary)
                } else {
                    ForEach(Array(viewModel.profile.availableIngredients.enumerated()), id: \.offset) { index, ingredient in
                        EditableTextRow(
                            text: ingredient,
                            onSave: { viewModel.editIngredient(ingredient, to: $0) }
                        )
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.removeIngredient(ingredient)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }

                IngredientInputView(
                    placeholder: "Add ingredient (e.g. chicken)",
                    text: $viewModel.newIngredientText,
                    onAdd: viewModel.addIngredient,
                    isDisabled: !viewModel.canAddIngredient
                )
            } header: {
                HStack {
                    Text("Available Ingredients")
                    Spacer()
                    Text("\(viewModel.profile.availableIngredients.count)/\(ProfileViewModel.maxIngredients)")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.secondary)
                }
            }
        }
        .listStyle(.insetGrouped)
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
}

// MARK: - Editable Text Row

struct EditableTextRow: View {
    let text: String
    let onSave: (String) -> Void

    @State private var isEditing = false
    @State private var editText = ""

    var body: some View {
        if isEditing {
            HStack {
                TextField("", text: $editText, onCommit: {
                    onSave(editText)
                    isEditing = false
                })
                .font(AppTheme.bodyFont)
                .textFieldStyle(.plain)

                Button {
                    onSave(editText)
                    isEditing = false
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppTheme.primary)
                }
                .buttonStyle(.plain)
            }
        } else {
            Text(text)
                .font(AppTheme.bodyFont)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    editText = text
                    isEditing = true
                }
        }
    }
}

// MARK: - Plan Status Card

struct PlanStatusCard: View {
    @ObservedObject var subscriptionManager: SubscriptionManager

    private var isPro: Bool { subscriptionManager.status == .pro }

    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isPro ? Color.primary : Color(.tertiarySystemFill))
                    .frame(width: 44, height: 44)

                Image(systemName: isPro ? "crown.fill" : "clock")
                    .font(.system(size: 18))
                    .foregroundColor(isPro ? Color(.systemBackground) : AppTheme.secondary)
            }

            // Text
            VStack(alignment: .leading, spacing: 3) {
                Text(subscriptionManager.status.rawValue)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(AppTheme.primary)

                switch subscriptionManager.status {
                case .free:
                    Text(subscriptionManager.trialRemainingText)
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.secondary)
                case .expired:
                    Text("Subscribe to continue")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.secondary)
                case .pro:
                    Text("Active subscription")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.secondary)
                }
            }

            Spacer()

            // Badge
            if isPro {
                Text("Pro")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(.systemBackground))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(AppTheme.primary)
                    .cornerRadius(8)
            } else if subscriptionManager.status == .free {
                HStack(spacing: 8) {
                    // Trial progress ring
                    ZStack {
                        Circle()
                            .stroke(Color(.tertiarySystemFill), lineWidth: 3)
                            .frame(width: 32, height: 32)
                        Circle()
                            .trim(from: 0, to: trialProgress)
                            .stroke(AppTheme.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .frame(width: 32, height: 32)
                            .rotationEffect(.degrees(-90))
                    }
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppTheme.secondary)
                }
            } else {
                // Expired state
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(AppTheme.secondary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isPro ? Color.primary.opacity(0.15) : Color(.separator).opacity(0.4), lineWidth: 1)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
    }

    private var trialProgress: CGFloat {
        let total = subscriptionManager.trialEndDate.timeIntervalSince(subscriptionManager.trialStartDate)
        let elapsed = Date().timeIntervalSince(subscriptionManager.trialStartDate)
        guard total > 0 else { return 0 }
        return CGFloat(max(0, min(1, 1 - (elapsed / total))))
    }
}
