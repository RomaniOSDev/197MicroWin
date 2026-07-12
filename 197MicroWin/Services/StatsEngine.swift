import Foundation

final class StatsEngine {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }

    func achievements() -> [Achievement] {
        storageService.load(forKey: StorageKeys.achievements)
    }

    func ritualSessions() -> [RitualSession] {
        storageService.load(forKey: StorageKeys.ritualSessions)
    }

    @discardableResult
    func recalculateAndSave() -> Stats {
        let achievements = achievements()
        let rituals = ritualSessions()
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!

        var byCategory: [Category: Int] = [:]
        var thisMonth = 0
        var thisWeek = 0
        var totalImpact = 0
        var winsByMood: [Mood: Int] = [:]
        var winsByWinSize: [WinSize: Int] = [:]
        var winsByEnergy: [EnergyLevel: Int] = [:]

        for achievement in achievements {
            byCategory[achievement.category, default: 0] += 1
            totalImpact += achievement.impactScore
            winsByWinSize[achievement.winSize, default: 0] += 1
            winsByEnergy[achievement.energy, default: 0] += 1
            if let mood = achievement.mood {
                winsByMood[mood, default: 0] += 1
            }
            if achievement.date >= startOfMonth { thisMonth += 1 }
            if achievement.date >= startOfWeek { thisWeek += 1 }
        }

        let total = achievements.count
        let averageImpact = total > 0 ? Double(totalImpact) / Double(total) : 0

        let uniqueDays = Set(achievements.map { calendar.startOfDay(for: $0.date) }).sorted(by: >)
        var streak = 0
        var lastDate: Date?
        let previousMax = (storageService.loadObject(forKey: StorageKeys.stats) as Stats?)?.maxStreak ?? 0
        var maxStreak = previousMax

        for date in uniqueDays {
            if let last = lastDate {
                let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: date), to: calendar.startOfDay(for: last)).day ?? 0
                if days <= 1 {
                    streak += 1
                } else {
                    break
                }
            } else {
                streak = 1
            }
            lastDate = date
        }

        if streak > maxStreak { maxStreak = streak }

        let ritualDays = Set(rituals.map { calendar.startOfDay(for: $0.date) }).count
        let lastRitual = rituals.map(\.completedAt).max()

        let stats = Stats(
            totalAchievements: total,
            achievementsByCategory: byCategory,
            favoriteCategory: byCategory.max(by: { $0.value < $1.value })?.key,
            currentStreak: streak,
            maxStreak: maxStreak,
            achievementsThisMonth: thisMonth,
            achievementsThisWeek: thisWeek,
            lastAchievementDate: achievements.map(\.date).max(),
            totalImpactScore: totalImpact,
            averageImpactScore: averageImpact,
            winsByMood: winsByMood,
            winsByWinSize: winsByWinSize,
            winsByEnergy: winsByEnergy,
            ritualDaysCompleted: ritualDays,
            lastRitualDate: lastRitual
        )

        storageService.saveObject(stats, forKey: StorageKeys.stats)
        return stats
    }

    func loadStats() -> Stats {
        storageService.loadObject(forKey: StorageKeys.stats) ?? Stats.empty
    }

    func moodInsights() -> [MoodInsight] {
        let achievements = achievements()
        guard !achievements.isEmpty else { return [] }

        var insights: [MoodInsight] = []
        let withMood = achievements.compactMap { achievement -> (Mood, Achievement)? in
            guard let mood = achievement.mood else { return nil }
            return (mood, achievement)
        }

        if !withMood.isEmpty {
            let moodCounts = Dictionary(grouping: withMood, by: { $0.0 }).mapValues(\.count)
            if let topMood = moodCounts.max(by: { $0.value < $1.value }) {
                insights.append(MoodInsight(
                    message: "You log more wins on \(topMood.key.rawValue.lowercased()) days",
                    icon: topMood.key.icon
                ))
            }
        }

        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let weekWins = achievements.filter { $0.date >= startOfWeek }

        for category in [Category.health, Category.fitness, Category.personal] {
            let categoryWins = weekWins.filter { $0.category == category && $0.mood != nil }
            if categoryWins.count >= 2 {
                let proudCount = categoryWins.filter { $0.mood == .proud || $0.mood == .motivated }.count
                if proudCount >= categoryWins.count / 2 {
                    insights.append(MoodInsight(
                        message: "\(category.rawValue) wins improve your weekly mood",
                        icon: category.icon
                    ))
                    break
                }
            }
        }

        if insights.isEmpty, let mood = withMood.first?.0 {
            insights.append(MoodInsight(
                message: "Keep tracking mood to unlock deeper insights",
                icon: mood.icon
            ))
        }

        return insights
    }

    func wins(for date: Date) -> [Achievement] {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: date)
        return achievements().filter { calendar.isDate($0.date, inSameDayAs: day) }
    }

    func daysWithWins(in month: Date) -> Set<Date> {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: month)
        return Set(
            achievements()
                .filter {
                    let c = calendar.dateComponents([.year, .month], from: $0.date)
                    return c.year == components.year && c.month == components.month
                }
                .map { calendar.startOfDay(for: $0.date) }
        )
    }

    func topWinsThisWeek(limit: Int = 3) -> [Achievement] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return achievements()
            .filter { $0.date >= startOfWeek && !$0.isMicroWin }
            .sorted { $0.impactScore > $1.impactScore }
            .prefix(limit)
            .map { $0 }
    }

    func mostActiveCategoryThisWeek() -> Category? {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        var counts: [Category: Int] = [:]
        for achievement in achievements() where achievement.date >= startOfWeek {
            counts[achievement.category, default: 0] += 1
        }
        return counts.max(by: { $0.value < $1.value })?.key
    }

    func weekStart(for date: Date = Date()) -> Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
    }

    func hasCompletedRitualToday() -> Bool {
        let calendar = Calendar.current
        return ritualSessions().contains { calendar.isDateInToday($0.date) }
    }
}
