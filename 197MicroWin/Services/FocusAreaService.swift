import Foundation

final class FocusAreaService {
    private let storageService: StorageServiceProtocol
    private let statsEngine: StatsEngine

    init(storageService: StorageServiceProtocol, statsEngine: StatsEngine) {
        self.storageService = storageService
        self.statsEngine = statsEngine
    }

    func currentSelection() -> FocusAreaSelection {
        let key = FocusAreaSelection.currentMonthKey()
        let all: [FocusAreaSelection] = storageService.load(forKey: StorageKeys.focusAreas)
        return all.first { $0.monthKey == key } ?? FocusAreaSelection(monthKey: key, categories: [])
    }

    func saveSelection(_ categories: [Category]) {
        let key = FocusAreaSelection.currentMonthKey()
        var all: [FocusAreaSelection] = storageService.load(forKey: StorageKeys.focusAreas)
        all.removeAll { $0.monthKey == key }
        all.append(FocusAreaSelection(monthKey: key, categories: Array(categories.prefix(3))))
        storageService.save(all, forKey: StorageKeys.focusAreas)
    }

    func progress(for category: Category) -> Int {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        return statsEngine.achievements().filter { $0.category == category && $0.date >= startOfMonth }.count
    }

    func neglectedAreas() -> [Category] {
        currentSelection().categories.filter { progress(for: $0) == 0 }
    }
}
