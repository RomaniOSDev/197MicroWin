import SwiftUI
import Combine

@MainActor
final class AchievementListViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var searchText = ""
    @Published var selectedCategory: Category?
    @Published var showFavoritesOnly = false

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let filterCategory: Category?

    var filteredAchievements: [Achievement] {
        var result = achievements

        if let filterCategory {
            result = result.filter { $0.category == filterCategory }
        }

        if let selectedCategory {
            result = result.filter { $0.category == selectedCategory }
        }

        if showFavoritesOnly {
            result = result.filter(\.isFavorite)
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                ($0.description?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }

        return result.sorted { $0.date > $1.date }
    }

    init(category: Category? = nil, storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.filterCategory = category
        self.storageService = storageService
        self.coordinator = coordinator
        loadAchievements()
    }

    func loadAchievements() {
        achievements = storageService.load(forKey: StorageKeys.achievements)
    }

    func deleteAchievement(_ achievement: Achievement) {
        var allAchievements = achievements
        allAchievements.removeAll { $0.id == achievement.id }
        storageService.save(allAchievements, forKey: StorageKeys.achievements)
        loadAchievements()
    }

    func toggleFavorite(_ achievement: Achievement) {
        var updated = achievement
        updated.isFavorite.toggle()
        storageService.update(updated, forKey: StorageKeys.achievements)
        loadAchievements()
    }

    func goToAchievementDetail(_ achievement: Achievement) {
        coordinator.navigateToAchievementDetail(achievement: achievement)
    }

    func goToAchievementForm() {
        coordinator.navigateToAchievementForm()
    }

    func goBack() {
        coordinator.pop()
    }
}
