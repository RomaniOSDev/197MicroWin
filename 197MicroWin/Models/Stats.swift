import Foundation

struct Stats: Codable {
    var totalAchievements: Int
    var achievementsByCategory: [Category: Int]
    var favoriteCategory: Category?
    var currentStreak: Int
    var maxStreak: Int
    var achievementsThisMonth: Int
    var achievementsThisWeek: Int
    var lastAchievementDate: Date?
    var totalImpactScore: Int
    var averageImpactScore: Double
    var winsByMood: [Mood: Int]
    var winsByWinSize: [WinSize: Int]
    var winsByEnergy: [EnergyLevel: Int]
    var ritualDaysCompleted: Int
    var lastRitualDate: Date?

    static var empty: Stats {
        Stats(
            totalAchievements: 0,
            achievementsByCategory: [:],
            favoriteCategory: nil,
            currentStreak: 0,
            maxStreak: 0,
            achievementsThisMonth: 0,
            achievementsThisWeek: 0,
            lastAchievementDate: nil,
            totalImpactScore: 0,
            averageImpactScore: 0,
            winsByMood: [:],
            winsByWinSize: [:],
            winsByEnergy: [:],
            ritualDaysCompleted: 0,
            lastRitualDate: nil
        )
    }

    init(
        totalAchievements: Int,
        achievementsByCategory: [Category: Int],
        favoriteCategory: Category?,
        currentStreak: Int,
        maxStreak: Int,
        achievementsThisMonth: Int,
        achievementsThisWeek: Int,
        lastAchievementDate: Date?,
        totalImpactScore: Int = 0,
        averageImpactScore: Double = 0,
        winsByMood: [Mood: Int] = [:],
        winsByWinSize: [WinSize: Int] = [:],
        winsByEnergy: [EnergyLevel: Int] = [:],
        ritualDaysCompleted: Int = 0,
        lastRitualDate: Date? = nil
    ) {
        self.totalAchievements = totalAchievements
        self.achievementsByCategory = achievementsByCategory
        self.favoriteCategory = favoriteCategory
        self.currentStreak = currentStreak
        self.maxStreak = maxStreak
        self.achievementsThisMonth = achievementsThisMonth
        self.achievementsThisWeek = achievementsThisWeek
        self.lastAchievementDate = lastAchievementDate
        self.totalImpactScore = totalImpactScore
        self.averageImpactScore = averageImpactScore
        self.winsByMood = winsByMood
        self.winsByWinSize = winsByWinSize
        self.winsByEnergy = winsByEnergy
        self.ritualDaysCompleted = ritualDaysCompleted
        self.lastRitualDate = lastRitualDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalAchievements = try container.decode(Int.self, forKey: .totalAchievements)
        achievementsByCategory = try container.decode([Category: Int].self, forKey: .achievementsByCategory)
        favoriteCategory = try container.decodeIfPresent(Category.self, forKey: .favoriteCategory)
        currentStreak = try container.decode(Int.self, forKey: .currentStreak)
        maxStreak = try container.decode(Int.self, forKey: .maxStreak)
        achievementsThisMonth = try container.decode(Int.self, forKey: .achievementsThisMonth)
        achievementsThisWeek = try container.decode(Int.self, forKey: .achievementsThisWeek)
        lastAchievementDate = try container.decodeIfPresent(Date.self, forKey: .lastAchievementDate)
        totalImpactScore = try container.decodeIfPresent(Int.self, forKey: .totalImpactScore) ?? 0
        averageImpactScore = try container.decodeIfPresent(Double.self, forKey: .averageImpactScore) ?? 0
        winsByMood = try container.decodeIfPresent([Mood: Int].self, forKey: .winsByMood) ?? [:]
        winsByWinSize = try container.decodeIfPresent([WinSize: Int].self, forKey: .winsByWinSize) ?? [:]
        winsByEnergy = try container.decodeIfPresent([EnergyLevel: Int].self, forKey: .winsByEnergy) ?? [:]
        ritualDaysCompleted = try container.decodeIfPresent(Int.self, forKey: .ritualDaysCompleted) ?? 0
        lastRitualDate = try container.decodeIfPresent(Date.self, forKey: .lastRitualDate)
    }

    enum CodingKeys: String, CodingKey {
        case totalAchievements, achievementsByCategory, favoriteCategory
        case currentStreak, maxStreak, achievementsThisMonth, achievementsThisWeek
        case lastAchievementDate, totalImpactScore, averageImpactScore
        case winsByMood, winsByWinSize, winsByEnergy
        case ritualDaysCompleted, lastRitualDate
    }
}

struct MoodInsight: Identifiable, Hashable {
    let id = UUID()
    let message: String
    let icon: String
}
