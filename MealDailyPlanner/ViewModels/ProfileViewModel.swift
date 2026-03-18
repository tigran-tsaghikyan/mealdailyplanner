import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile {
        didSet { save() }
    }

    @Published var newAllergyText = ""
    @Published var newIngredientText = ""
    @Published var newMemberName = ""

    // MARK: - Limits

    static let maxFamilyMembers = 10
    static let minFamilyMembers = 1
    static let maxAllergies = 15
    static let maxIngredients = 20

    var canAddMember: Bool { profile.familyMembers.count < Self.maxFamilyMembers }
    var canRemoveMember: Bool { profile.familyMembers.count > Self.minFamilyMembers }
    var canAddAllergy: Bool { profile.allergies.count < Self.maxAllergies }
    var canAddIngredient: Bool { profile.availableIngredients.count < Self.maxIngredients }

    private let storage = StorageManager.shared

    init() {
        self.profile = StorageManager.shared.loadProfile()
    }

    // MARK: - Family Members

    var familySize: Int { profile.familyMembers.count }

    var scalingMultiplier: Double { profile.scalingMultiplier }

    func addMember() {
        let name = newMemberName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty, canAddMember else { return }
        profile.familyMembers.append(FamilyMember(name: name, isChild: false))
        newMemberName = ""
    }

    func removeMember(_ member: FamilyMember) {
        guard canRemoveMember else { return }
        profile.familyMembers.removeAll { $0.id == member.id }
    }

    func removeMember(at offsets: IndexSet) {
        guard canRemoveMember else { return }
        profile.familyMembers.remove(atOffsets: offsets)
    }

    func toggleChildStatus(for member: FamilyMember) {
        guard let index = profile.familyMembers.firstIndex(where: { $0.id == member.id }) else { return }
        profile.familyMembers[index].isChild.toggle()
    }

    func renameMember(_ member: FamilyMember, to newName: String) {
        let trimmed = newName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty,
              let index = profile.familyMembers.firstIndex(where: { $0.id == member.id }) else { return }
        profile.familyMembers[index].name = trimmed
    }

    // MARK: - Allergies

    func addAllergy() {
        let allergy = newAllergyText.trimmingCharacters(in: .whitespaces)
        guard !allergy.isEmpty, canAddAllergy else { return }
        guard !profile.allergies.contains(where: { $0.lowercased() == allergy.lowercased() }) else { return }
        profile.allergies.append(allergy)
        newAllergyText = ""
    }

    func removeAllergy(_ allergy: String) {
        profile.allergies.removeAll { $0 == allergy }
    }

    func editAllergy(_ old: String, to newValue: String) {
        let trimmed = newValue.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, let index = profile.allergies.firstIndex(of: old) else { return }
        profile.allergies[index] = trimmed
    }

    func removeAllergy(at offsets: IndexSet) {
        profile.allergies.remove(atOffsets: offsets)
    }

    // MARK: - Available Ingredients

    func addIngredient() {
        let ingredient = newIngredientText.trimmingCharacters(in: .whitespaces)
        guard !ingredient.isEmpty, canAddIngredient else { return }
        guard !profile.availableIngredients.contains(where: { $0.lowercased() == ingredient.lowercased() }) else { return }
        profile.availableIngredients.append(ingredient)
        newIngredientText = ""
    }

    func removeIngredient(_ ingredient: String) {
        profile.availableIngredients.removeAll { $0 == ingredient }
    }

    func editIngredient(_ old: String, to newValue: String) {
        let trimmed = newValue.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, let index = profile.availableIngredients.firstIndex(of: old) else { return }
        profile.availableIngredients[index] = trimmed
    }

    func removeIngredient(at offsets: IndexSet) {
        profile.availableIngredients.remove(atOffsets: offsets)
    }

    // MARK: - Persistence

    private func save() {
        storage.saveProfile(profile)
    }
}
