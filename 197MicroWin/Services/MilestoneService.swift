import Foundation

final class MilestoneService {
    private let storageService: StorageServiceProtocol
    private let statsEngine: StatsEngine

    init(storageService: StorageServiceProtocol, statsEngine: StatsEngine) {
        self.storageService = storageService
        self.statsEngine = statsEngine
    }

    func getMilestones() -> [Milestone] {
        storageService.load(forKey: StorageKeys.milestones)
    }

    @discardableResult
    func evaluateAndUnlock() -> [Milestone] {
        let stats = statsEngine.recalculateAndSave()
        let achievements = statsEngine.achievements()
        let rituals = statsEngine.ritualSessions()
        var unlocked = getMilestones()
        let existing = Set(unlocked.map(\.type))

        func unlock(_ type: MilestoneType) {
            guard !existing.contains(type) else { return }
            unlocked.append(Milestone(id: UUID(), type: type, unlockedAt: Date()))
        }

        if stats.totalAchievements >= 1 { unlock(.firstWin) }
        if stats.totalAchievements >= 25 { unlock(.twentyFiveWins) }
        if stats.ritualDaysCompleted >= 1 { unlock(.firstRitual) }
        if stats.ritualDaysCompleted >= 10 { unlock(.tenRituals) }
        if stats.ritualDaysCompleted >= 7 { unlock(.sevenDayAwareness) }

        let calendar = Calendar.current
        let startOfWeek = statsEngine.weekStart()
        let weekWins = achievements.filter { $0.date >= startOfWeek }
        let weekCategories = Set(weekWins.map(\.category))
        if weekCategories.count >= 3 { unlock(.balancedWeek) }

        if !weekWins.isEmpty {
            let avg = Double(weekWins.map(\.impactScore).reduce(0, +)) / Double(weekWins.count)
            if avg >= 4 { unlock(.highImpactWeek) }
        }

        storageService.save(unlocked, forKey: StorageKeys.milestones)
        return unlocked
    }

    func progress(for type: MilestoneType) -> Double {
        let stats = statsEngine.loadStats()
        let achievements = statsEngine.achievements()
        let rituals = statsEngine.ritualSessions()

        switch type {
        case .firstWin:
            return min(1, Double(stats.totalAchievements))
        case .twentyFiveWins:
            return min(1, Double(stats.totalAchievements) / 25)
        case .sevenDayAwareness:
            return min(1, Double(stats.ritualDaysCompleted) / 7)
        case .firstRitual:
            return rituals.isEmpty ? 0 : 1
        case .tenRituals:
            return min(1, Double(stats.ritualDaysCompleted) / 10)
        case .balancedWeek:
            let startOfWeek = statsEngine.weekStart()
            let count = Set(achievements.filter { $0.date >= startOfWeek }.map(\.category)).count
            return min(1, Double(count) / 3)
        case .highImpactWeek:
            let startOfWeek = statsEngine.weekStart()
            let weekWins = achievements.filter { $0.date >= startOfWeek }
            guard !weekWins.isEmpty else { return 0 }
            let avg = Double(weekWins.map(\.impactScore).reduce(0, +)) / Double(weekWins.count)
            return min(1, avg / 4)
        }
    }
}
