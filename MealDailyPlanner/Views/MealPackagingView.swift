import SwiftUI

struct MealPackagingView: View {
    let meal: Meal
    let familyMembers: [FamilyMember]

    @State private var isExpanded = false

    private var portions: [MemberPortion] {
        PortionCalculator.portions(for: familyMembers)
    }

    private var hasAnyDefaultPortions: Bool {
        portions.contains { $0.isDefaultPortion }
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Toggle Header
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: AppTheme.spacingSM) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.secondary)

                    Text("How to serve")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.secondary)

                    Spacer()

                    // Safety hint badge (always visible when there are default portions)
                    if hasAnyDefaultPortions && !isExpanded {
                        HStack(spacing: 3) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 10))
                            Text("Safe defaults")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(Palette.accentText)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Palette.accentSoft)
                        .clipShape(Capsule())
                    }

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppTheme.secondary)
                }
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // MARK: - Expanded Content
            if isExpanded {
                VStack(spacing: 0) {
                    // Safety notice (shown once at top when any child uses default)
                    if hasAnyDefaultPortions {
                        HStack(spacing: AppTheme.spacingSM) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Palette.accentText)
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Children without targets use safe default portions")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Palette.accentText)
                                Text("Set targets in Profile to personalise their portions.")
                                    .font(.system(size: 11))
                                    .foregroundColor(AppTheme.secondary)
                            }
                        }
                        .padding(AppTheme.spacingMD)
                        .background(Palette.accentSoft.opacity(0.6))
                    }

                    // Per-member sections
                    ForEach(Array(portions.enumerated()), id: \.element.id) { index, portion in
                        memberSection(portion: portion)

                        if index < portions.count - 1 {
                            Rectangle()
                                .fill(Palette.divider)
                                .frame(height: 0.5)
                                .padding(.leading, AppTheme.spacingMD)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: - Member Section

    @ViewBuilder
    private func memberSection(portion: MemberPortion) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            // Member header
            HStack(spacing: 6) {
                // Avatar circle
                ZStack {
                    Circle()
                        .fill(portion.isDefaultPortion
                              ? Palette.accentSoft
                              : Palette.fill)
                        .frame(width: 28, height: 28)

                    if portion.isDefaultPortion {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Palette.accentText)
                    } else {
                        Text(String(portion.member.name.prefix(1)).uppercased())
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppTheme.primary)
                    }
                }

                // Name + type
                VStack(alignment: .leading, spacing: 1) {
                    Text(portion.member.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.primary)

                    Text(portion.isDefaultPortion
                         ? "Child · ½ safe default"
                         : portion.member.isChild ? "Child · personalised" : "Adult · personalised")
                        .font(.system(size: 11))
                        .foregroundColor(portion.isDefaultPortion ? Palette.accentText : AppTheme.secondary)
                }

                Spacer()

                // Calorie tag
                if let cal = portion.caloriesLabel {
                    Text(cal)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(AppTheme.secondary)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Palette.fill)
                        .clipShape(Capsule())
                }
            }

            // Ingredient amounts
            VStack(spacing: 3) {
                ForEach(meal.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.secondary)
                        Spacer()
                        Text(ingredient.scaled(for: portion.portionFactor))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(AppTheme.primary)
                    }
                }
            }
            .padding(.leading, 34) // align under name, past the avatar
        }
        .padding(.horizontal, AppTheme.spacingMD)
        .padding(.vertical, 10)
        .background(portion.isDefaultPortion
                    ? Palette.accentSoft.opacity(0.3)
                    : Color.clear)
    }
}
