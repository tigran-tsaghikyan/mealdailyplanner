import Foundation

struct FamilyMember: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var isChild: Bool

    var scalingFactor: Double {
        isChild ? 0.5 : 1.0
    }
}
