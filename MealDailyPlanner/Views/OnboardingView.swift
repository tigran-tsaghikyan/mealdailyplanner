import SwiftUI

// MARK: - Onboarding Step

private enum OnboardingStep: Int, CaseIterable {
    case welcome
    case family
    case allergies
    case ingredients
    case ready

    var title: String {
        switch self {
        case .welcome:     return ""
        case .family:      return "Your Family"
        case .allergies:   return "Food Allergies"
        case .ingredients: return "Your Kitchen"
        case .ready:       return ""
        }
    }

    /// Steps that show the progress indicator (exclude welcome & ready)
    var showsProgress: Bool {
        switch self {
        case .family, .allergies, .ingredients: return true
        default: return false
        }
    }

    var progressIndex: Int {
        switch self {
        case .family:      return 0
        case .allergies:   return 1
        case .ingredients: return 2
        default:           return 0
        }
    }
}

// MARK: - OnboardingView

struct OnboardingView: View {
    let onComplete: () -> Void

    @StateObject private var vm = ProfileViewModel()
    @State private var step: OnboardingStep = .welcome
    @State private var animateIn = false

    private let totalProgressSteps = 3

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress dots (only for middle steps)
                if step.showsProgress {
                    progressBar
                        .padding(.top, AppTheme.spacingMD)
                        .transition(.opacity)
                }

                // Step content
                ZStack {
                    switch step {
                    case .welcome:
                        welcomeStep
                            .transition(stepTransition(forward: true))
                    case .family:
                        familyStep
                            .transition(stepTransition(forward: step.rawValue > OnboardingStep.welcome.rawValue))
                    case .allergies:
                        allergiesStep
                            .transition(stepTransition(forward: true))
                    case .ingredients:
                        ingredientsStep
                            .transition(stepTransition(forward: true))
                    case .ready:
                        readyStep
                            .transition(stepTransition(forward: true))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) { animateIn = true }
        }
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalProgressSteps, id: \.self) { index in
                Capsule()
                    .fill(index <= step.progressIndex ? AppTheme.primary : Color(.tertiarySystemFill))
                    .frame(height: 4)
                    .animation(.spring(response: 0.4), value: step)
            }
        }
        .padding(.horizontal, AppTheme.spacingXL)
        .padding(.bottom, AppTheme.spacingSM)
    }

    // MARK: - Step 0: Welcome

    private var welcomeStep: some View {
        VStack(spacing: AppTheme.spacingLG) {
            Spacer()

            VStack(spacing: AppTheme.spacingMD) {
                Text("🍽️")
                    .font(.system(size: 72))

                Text("Welcome to\nMealDailyPlanner")
                    .font(.system(size: 30, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppTheme.primary)

                Text("Let's set up your family profile so we can generate personalised daily meal plans just for you.")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.spacingLG)
            }

            Spacer()

            VStack(spacing: AppTheme.spacingMD) {
                featureRow(icon: "person.2.fill",     text: "Set up family members")
                featureRow(icon: "exclamationmark.triangle.fill", text: "Add any food allergies")
                featureRow(icon: "cart.fill",         text: "Tell us what's in your kitchen")
            }
            .padding(.horizontal, AppTheme.spacingXL)

            Spacer()

            primaryButton(title: "Get Started") {
                advance()
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.bottom, AppTheme.spacingXL)
        }
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : 20)
    }

    // MARK: - Step 1: Family

    private var familyStep: some View {
        VStack(spacing: 0) {
            stepHeader(
                icon: "person.2.fill",
                title: "Who's in your family?",
                subtitle: "Add at least one member to continue."
            )

            ScrollView {
                VStack(spacing: AppTheme.spacingXS) {
                    // Member list
                    ForEach(vm.profile.familyMembers) { member in
                        onboardingMemberRow(member)
                    }

                    // Add member input
                    addMemberRow
                }
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.top, AppTheme.spacingMD)
            }

            Spacer()

            bottomButtons(
                primaryTitle: "Next →",
                primaryDisabled: vm.profile.familyMembers.isEmpty,
                showBack: false,
                showSkip: false,
                onPrimary: { advance() },
                onBack: {},
                onSkip: {}
            )
        }
    }

    // MARK: - Step 2: Allergies

    private var allergiesStep: some View {
        VStack(spacing: 0) {
            stepHeader(
                icon: "exclamationmark.triangle.fill",
                title: "Any food allergies?",
                subtitle: "We'll exclude these from all meal suggestions."
            )

            ScrollView {
                VStack(spacing: AppTheme.spacingXS) {
                    if vm.profile.allergies.isEmpty {
                        emptyHint(text: "No allergies added — all foods included")
                    } else {
                        ForEach(vm.profile.allergies, id: \.self) { allergy in
                            onboardingChipRow(text: allergy) {
                                vm.removeAllergy(allergy)
                            }
                        }
                    }

                    addChipRow(
                        placeholder: "e.g. peanuts, gluten…",
                        text: $vm.newAllergyText,
                        onAdd: vm.addAllergy,
                        isDisabled: !vm.canAddAllergy
                    )
                }
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.top, AppTheme.spacingMD)
            }

            Spacer()

            bottomButtons(
                primaryTitle: "Next →",
                primaryDisabled: false,
                showBack: true,
                showSkip: true,
                onPrimary: { advance() },
                onBack: { goBack() },
                onSkip: { advance() }
            )
        }
    }

    // MARK: - Step 3: Ingredients

    private var ingredientsStep: some View {
        VStack(spacing: 0) {
            stepHeader(
                icon: "cart.fill",
                title: "What's in your kitchen?",
                subtitle: "We'll prioritise meals using ingredients you already have."
            )

            ScrollView {
                VStack(spacing: AppTheme.spacingXS) {
                    if vm.profile.availableIngredients.isEmpty {
                        emptyHint(text: "No ingredients added — all recipes available")
                    } else {
                        ForEach(vm.profile.availableIngredients, id: \.self) { ingredient in
                            onboardingChipRow(text: ingredient) {
                                vm.removeIngredient(ingredient)
                            }
                        }
                    }

                    addChipRow(
                        placeholder: "e.g. chicken, rice, eggs…",
                        text: $vm.newIngredientText,
                        onAdd: vm.addIngredient,
                        isDisabled: !vm.canAddIngredient
                    )
                }
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.top, AppTheme.spacingMD)
            }

            Spacer()

            bottomButtons(
                primaryTitle: "Next →",
                primaryDisabled: false,
                showBack: true,
                showSkip: true,
                onPrimary: { advance() },
                onBack: { goBack() },
                onSkip: { advance() }
            )
        }
    }

    // MARK: - Step 4: Ready

    private var readyStep: some View {
        VStack(spacing: AppTheme.spacingLG) {
            Spacer()

            VStack(spacing: AppTheme.spacingMD) {
                Text("✅")
                    .font(.system(size: 72))

                Text("You're all set!")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(AppTheme.primary)

                Text("Here's your family summary:")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.secondary)
            }

            // Summary card
            VStack(spacing: AppTheme.spacingMD) {
                summaryRow(
                    icon: "person.2.fill",
                    label: "\(vm.profile.familyMembers.count) family member\(vm.profile.familyMembers.count == 1 ? "" : "s")",
                    detail: vm.profile.familyMembers.map(\.name).joined(separator: ", ")
                )

                if !vm.profile.allergies.isEmpty {
                    summaryRow(
                        icon: "exclamationmark.triangle.fill",
                        label: "\(vm.profile.allergies.count) allergi\(vm.profile.allergies.count == 1 ? "y" : "es")",
                        detail: vm.profile.allergies.joined(separator: ", ")
                    )
                }

                if !vm.profile.availableIngredients.isEmpty {
                    summaryRow(
                        icon: "cart.fill",
                        label: "\(vm.profile.availableIngredients.count) ingredient\(vm.profile.availableIngredients.count == 1 ? "" : "s")",
                        detail: vm.profile.availableIngredients.prefix(3).joined(separator: ", ") +
                                (vm.profile.availableIngredients.count > 3 ? "…" : "")
                    )
                }
            }
            .padding(AppTheme.spacingMD)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .padding(.horizontal, AppTheme.spacingMD)

            Spacer()

            primaryButton(title: "Generate My First Plan 🍽️") {
                StorageManager.shared.hasCompletedOnboarding = true
                onComplete()
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.bottom, AppTheme.spacingXL)
        }
    }

    // MARK: - Reusable Sub-views

    private func stepHeader(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: AppTheme.spacingSM) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(AppTheme.primary)
                .padding(.top, AppTheme.spacingMD)
            Text(title)
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.primary)
            Text(subtitle)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.spacingLG)
        }
        .padding(.bottom, AppTheme.spacingSM)
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: AppTheme.spacingMD) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.primary)
                .frame(width: 28)
            Text(text)
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.primary)
            Spacer()
        }
    }

    private func onboardingMemberRow(_ member: FamilyMember) -> some View {
        OnboardingMemberRowView(
            member: member,
            onToggle:  { vm.toggleChildStatus(for: member) },
            onRename:  { vm.renameMember(member, to: $0) },
            onRemove:  { vm.removeMember(member) }
        )
    }

    private var addMemberRow: some View {
        HStack {
            TextField("Member name", text: $vm.newMemberName)
                .font(AppTheme.bodyFont)
                .onSubmit { vm.addMember() }

            Button {
                vm.addMember()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(vm.newMemberName.trimmingCharacters(in: .whitespaces).isEmpty || !vm.canAddMember
                                    ? Color(.tertiaryLabel)
                                    : AppTheme.primary)
            }
            .buttonStyle(.plain)
            .disabled(vm.newMemberName.trimmingCharacters(in: .whitespaces).isEmpty || !vm.canAddMember)
        }
        .padding(AppTheme.spacingMD)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private func onboardingChipRow(text: String, onRemove: @escaping () -> Void) -> some View {
        HStack {
            Text(text)
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.primary)
            Spacer()
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(.tertiaryLabel))
                    .font(.system(size: 18))
            }
            .buttonStyle(.plain)
        }
        .padding(AppTheme.spacingMD)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private func addChipRow(
        placeholder: String,
        text: Binding<String>,
        onAdd: @escaping () -> Void,
        isDisabled: Bool
    ) -> some View {
        HStack {
            TextField(placeholder, text: text)
                .font(AppTheme.bodyFont)
                .onSubmit { onAdd() }
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(text.wrappedValue.trimmingCharacters(in: .whitespaces).isEmpty || isDisabled
                                    ? Color(.tertiaryLabel)
                                    : AppTheme.primary)
            }
            .buttonStyle(.plain)
            .disabled(text.wrappedValue.trimmingCharacters(in: .whitespaces).isEmpty || isDisabled)
        }
        .padding(AppTheme.spacingMD)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private func emptyHint(text: String) -> some View {
        Text(text)
            .font(AppTheme.captionFont)
            .foregroundColor(AppTheme.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppTheme.spacingMD)
    }

    private func summaryRow(icon: String, label: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.spacingMD) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundColor(AppTheme.primary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(AppTheme.bodyFont)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.primary)
                Text(detail)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondary)
                    .lineLimit(2)
            }
            Spacer()
        }
    }

    private func bottomButtons(
        primaryTitle: String,
        primaryDisabled: Bool,
        showBack: Bool,
        showSkip: Bool,
        onPrimary: @escaping () -> Void,
        onBack: @escaping () -> Void,
        onSkip: @escaping () -> Void
    ) -> some View {
        VStack(spacing: AppTheme.spacingSM) {
            primaryButton(title: primaryTitle, action: onPrimary)
                .disabled(primaryDisabled)
                .opacity(primaryDisabled ? 0.4 : 1.0)
                .padding(.horizontal, AppTheme.spacingMD)

            HStack {
                if showBack {
                    Button("← Back", action: onBack)
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.secondary)
                }
                Spacer()
                if showSkip {
                    Button("Skip", action: onSkip)
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.secondary)
                }
            }
            .padding(.horizontal, AppTheme.spacingXL)
        }
        .padding(.bottom, AppTheme.spacingXL)
    }

    private func primaryButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.headlineFont)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.primary)
                .foregroundColor(Color(.systemBackground))
                .cornerRadius(14)
        }
    }

    // MARK: - Navigation

    private func advance() {
        let all = OnboardingStep.allCases
        guard let current = all.firstIndex(of: step),
              current + 1 < all.count else { return }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            step = all[current + 1]
        }
    }

    private func goBack() {
        let all = OnboardingStep.allCases
        guard let current = all.firstIndex(of: step), current > 0 else { return }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            step = all[current - 1]
        }
    }

    private func stepTransition(forward: Bool) -> AnyTransition {
        .asymmetric(
            insertion: .move(edge: forward ? .trailing : .leading).combined(with: .opacity),
            removal:   .move(edge: forward ? .leading  : .trailing).combined(with: .opacity)
        )
    }
}

// MARK: - Onboarding Member Row (needs own @State for editing)

private struct OnboardingMemberRowView: View {
    let member: FamilyMember
    let onToggle: () -> Void
    let onRename: (String) -> Void
    let onRemove: () -> Void

    @State private var isEditing = false
    @State private var editText  = ""

    var body: some View {
        HStack(spacing: AppTheme.spacingMD) {
            // Name (tap to edit)
            VStack(alignment: .leading, spacing: 2) {
                if isEditing {
                    TextField("Name", text: $editText)
                        .font(AppTheme.bodyFont)
                        .textFieldStyle(.plain)
                        .onSubmit { commitEdit() }
                        .onAppear { editText = member.name }
                } else {
                    Text(member.name)
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.primary)
                        .onTapGesture {
                            editText  = member.name
                            isEditing = true
                        }
                }

                Text(member.isChild ? "Child (×0.5)" : "Adult (×1.0)")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Confirm edit OR adult/child toggle
            if isEditing {
                Button { commitEdit() } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                }
                .buttonStyle(.plain)
            } else {
                Button(action: onToggle) {
                    Text(member.isChild ? "Child" : "Adult")
                        .font(AppTheme.captionFont)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(member.isChild ? Color.gray.opacity(0.15) : Color.primary.opacity(0.1))
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)

                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(.tertiaryLabel))
                        .font(.system(size: 18))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(AppTheme.spacingMD)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private func commitEdit() {
        onRename(editText)
        isEditing = false
    }
}
