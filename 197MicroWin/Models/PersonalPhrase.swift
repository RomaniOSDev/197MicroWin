import Foundation

struct PersonalPhrase: Identifiable, Codable, Hashable {
    let id: UUID
    var text: String
    var createdAt: Date
}
