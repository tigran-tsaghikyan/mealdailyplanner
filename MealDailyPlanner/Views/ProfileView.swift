import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.spacingLG) {
                // MARK: - Family Members
                VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
                    HStack {
                        Text("Family Members")
                            .font(AppTheme.titleFont)
                        Spacer()
                        Text("\(viewModel.familySize)")
                            .font(AppTheme.headlineFont)
                            .foregroundColor(AppTheme.secondary)
                        ScalingInfoView(profile: viewModel.profile)
                    }

                    ForEach(viewModel.profile.familyMembers) { member in
                        FamilyMemberRow(member: member) {
                            viewModel.toggleChildStatus(for: member)
                        }
                    }
                    .onDelete(perform: viewModel.removeMember)

                    if viewModel.familySize < 10 {
                        IngredientInputView(
                            placeholder: "Member name",
                            text: $viewModel.newMemberName,
                            onAdd: viewModel.addMember
                        )
                        .padding(.top, AppTheme.spacingXS)
                    }
                }

                Divider()

                // MARK: - Allergies
                VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
                    Text("Allergies")
                        .font(AppTheme.titleFont)

                    if viewModel.profile.allergies.isEmpty {
                        Text("No allergies added")
                            .font(AppTheme.captionFont)
                            .foregroundColor(AppTheme.secondary)
                    } else {
                        FlowLayout(items: viewModel.profile.allergies) { allergy in
                            TagView(text: allergy) {
                                if let index = viewModel.profile.allergies.firstIndex(of: allergy) {
                                    viewModel.profile.allergies.remove(at: index)
                                }
                            }
                        }
                    }

                    IngredientInputView(
                        placeholder: "Add allergy (e.g. peanuts)",
                        text: $viewModel.newAllergyText,
                        onAdd: viewModel.addAllergy
                    )
                }

                Divider()

                // MARK: - Available Ingredients
                VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
                    Text("Available Ingredients")
                        .font(AppTheme.titleFont)

                    if viewModel.profile.availableIngredients.isEmpty {
                        Text("No ingredients added — all recipes available")
                            .font(AppTheme.captionFont)
                            .foregroundColor(AppTheme.secondary)
                    } else {
                        FlowLayout(items: viewModel.profile.availableIngredients) { ingredient in
                            TagView(text: ingredient) {
                                if let index = viewModel.profile.availableIngredients.firstIndex(of: ingredient) {
                                    viewModel.profile.availableIngredients.remove(at: index)
                                }
                            }
                        }
                    }

                    IngredientInputView(
                        placeholder: "Add ingredient (e.g. chicken)",
                        text: $viewModel.newIngredientText,
                        onAdd: viewModel.addIngredient
                    )
                }
            }
            .padding(AppTheme.spacingMD)
        }
    }
}

// MARK: - Tag View

struct TagView: View {
    let text: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(AppTheme.captionFont)
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(16)
    }
}

// MARK: - Flow Layout

struct FlowLayout<Item: Hashable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 6) {
            ForEach(items, id: \.self) { item in
                content(item)
            }
        }
    }
}
