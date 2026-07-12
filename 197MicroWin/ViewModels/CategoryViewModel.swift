import SwiftUI
import Combine

@MainActor
final class CategoriesViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var categoryStats: [(Category, Int)] = []
    @Published var favoriteCategory: Category?

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    init(storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.coordinator = coordinator
        loadData()
    }

    func loadData() {
        achievements = storageService.load(forKey: StorageKeys.achievements)
        var stats: [Category: Int] = [:]
        for achievement in achievements {
            stats[achievement.category] = (stats[achievement.category] ?? 0) + 1
        }
        categoryStats = stats.map { ($0, $1) }.sorted { $0.1 > $1.1 }

        if let statsObject: Stats = storageService.loadObject(forKey: StorageKeys.stats) {
            favoriteCategory = statsObject.favoriteCategory
        }
    }

    func goToCategoryAchievements(_ category: Category) {
        coordinator.navigateToAchievementList(category: category)
    }

    func goBack() {
        coordinator.pop()
    }
}
