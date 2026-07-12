import Foundation

struct RitualSession: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    var primaryWinId: UUID
    var microWinId: UUID?
    var completedAt: Date
}
