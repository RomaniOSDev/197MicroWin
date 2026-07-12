import Foundation

struct WeeklyReflection: Identifiable, Codable, Hashable {
    let id: UUID
    let weekStart: Date
    var topWinIds: [UUID]
    var mostActiveCategory: Category?
    var patternNote: String
    var intention: String
    var completedAt: Date
}
