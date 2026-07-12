import Foundation

final class WeeklyReflectionService {
    private let storageService: StorageServiceProtocol
    private let statsEngine: StatsEngine

    init(storageService: StorageServiceProtocol, statsEngine: StatsEngine) {
        self.storageService = storageService
        self.statsEngine = statsEngine
    }

    func reflections() -> [WeeklyReflection] {
        storageService.load(forKey: StorageKeys.weeklyReflections)
    }

    func isDue() -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        guard weekday == 1 || weekday == 2 else { return false }

        let weekStart = statsEngine.weekStart()
        return !reflections().contains { calendar.isDate($0.weekStart, inSameDayAs: weekStart) }
    }

    func saveReflection(patternNote: String, intention: String) {
        let topWins = statsEngine.topWinsThisWeek()
        let reflection = WeeklyReflection(
            id: UUID(),
            weekStart: statsEngine.weekStart(),
            topWinIds: topWins.map(\.id),
            mostActiveCategory: statsEngine.mostActiveCategoryThisWeek(),
            patternNote: patternNote,
            intention: intention,
            completedAt: Date()
        )
        storageService.append(reflection, forKey: StorageKeys.weeklyReflections)
    }

    func latestReflection() -> WeeklyReflection? {
        reflections().sorted { $0.completedAt > $1.completedAt }.first
    }
}
