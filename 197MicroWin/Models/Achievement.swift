import Foundation

struct Achievement: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var description: String?
    var category: Category
    var date: Date
    var isFavorite: Bool
    var createdAt: Date
    var winSize: WinSize
    var energy: EnergyLevel
    var impactScore: Int
    var mood: Mood?
    var reflectionNote: String?
    var fromRitual: Bool
    var isMicroWin: Bool

    init(
        id: UUID,
        title: String,
        description: String? = nil,
        category: Category,
        date: Date,
        isFavorite: Bool,
        createdAt: Date,
        winSize: WinSize = .small,
        energy: EnergyLevel = .medium,
        impactScore: Int = 3,
        mood: Mood? = nil,
        reflectionNote: String? = nil,
        fromRitual: Bool = false,
        isMicroWin: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.date = date
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        self.winSize = winSize
        self.energy = energy
        self.impactScore = min(5, max(1, impactScore))
        self.mood = mood
        self.reflectionNote = reflectionNote
        self.fromRitual = fromRitual
        self.isMicroWin = isMicroWin
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        category = try container.decode(Category.self, forKey: .category)
        date = try container.decode(Date.self, forKey: .date)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        winSize = try container.decodeIfPresent(WinSize.self, forKey: .winSize) ?? .small
        energy = try container.decodeIfPresent(EnergyLevel.self, forKey: .energy) ?? .medium
        impactScore = min(5, max(1, try container.decodeIfPresent(Int.self, forKey: .impactScore) ?? 3))
        mood = try container.decodeIfPresent(Mood.self, forKey: .mood)
        reflectionNote = try container.decodeIfPresent(String.self, forKey: .reflectionNote)
        fromRitual = try container.decodeIfPresent(Bool.self, forKey: .fromRitual) ?? false
        isMicroWin = try container.decodeIfPresent(Bool.self, forKey: .isMicroWin) ?? false
    }

    enum CodingKeys: String, CodingKey {
        case id, title, description, category, date, isFavorite, createdAt
        case winSize, energy, impactScore, mood, reflectionNote, fromRitual, isMicroWin
    }
}
