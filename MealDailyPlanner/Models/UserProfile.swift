import Foundation

struct UserProfile: Codable {
    var familyMembers: [FamilyMember]
    var allergies: [String]
    var availableIngredients: [String]

    var familySize: Int { familyMembers.count }

    var scalingMultiplier: Double {
        familyMembers.reduce(0.0) { $0 + $1.scalingFactor }
    }

    static let `default` = UserProfile(
        familyMembers: [
            FamilyMember(name: "Adult 1", isChild: false),
            FamilyMember(name: "Adult 2", isChild: false)
        ],
        allergies: [],
        availableIngredients: []
    )
}
