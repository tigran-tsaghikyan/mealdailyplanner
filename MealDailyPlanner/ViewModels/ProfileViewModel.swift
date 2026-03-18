import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile {
        didSet { save() }
    }

    @Published var newAllergyText = ""
    @Published var newIngredientText = ""
    @Published var newMemberName = ""

    private let storage = StorageManager.shared

    init() {
        self.profile = StorageManager.shared.loadProfile()
    }

    // MARK: - Family Members

    var familySize: Int { profile.familyMembers.count }

    var scalingMultiplier: Double { profile.scalingMultiplier }

    func addMember() {
        let name = newMemberName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        guard profile.familyMembers.count < 10 else { return }
        profile.familyMembers.append(FamilyMember(name: name, isChild: false))
        newMemberName = ""
    }

    func removeMember(at offsets: IndexSet) {
        guard profile.familyMembers.count > 1 else { return }
        profile.familyMembers.remove(atOffsets: offsets)
    }

    func toggleChildStatus(for member: FamilyMember) {
        guard let index = profile.familyMembers.firstIndex(where: { $0.id == member.id }) else { return }
        profile.familyMembers[index].isChild.toggle()
    }

    // MARK: - Allergies

    func addAllergy() {
        let allergy = newAllergyText.trimmingCharacters(in: .whitespaces)
        guard !allergy.isEmpty else { return }
        guard !profile.allergies.contains(where: { $0.lowercased() == allergy.lowercased() }) else { return }
        profile.allergies.append(allergy)
        newAllergyText = ""
    }

    func removeAllergy(at offsets: IndexSet) {
        profile.allergies.remove(atOffsets: offsets)
    }

    // MARK: - Available Ingredients

    func addIngredient() {
        let ingredient = newIngredientText.trimmingCharacters(in: .whitespaces)
        guard !ingredient.isEmpty else { return }
        guard !profile.availableIngredients.contains(where: { $0.lowercased() == ingredient.lowercased() }) else { return }
        profile.availableIngredients.append(ingredient)
        newIngredientText = ""
    }

    func removeIngredient(at offsets: IndexSet) {
        profile.availableIngredients.remove(atOffsets: offsets)
    }

    // MARK: - Persistence

    private func save() {
        storage.saveProfile(profile)
    }
}
