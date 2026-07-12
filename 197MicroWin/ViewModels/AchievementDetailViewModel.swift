import SwiftUI
import Combine

@MainActor
final class AchievementDetailViewModel: ObservableObject {
    @Published var achievement: Achievement
    @Published var showDeleteAlert = false
    @Published var showShareSheet = false
    @Published var shareItems: [Any] = []

    private let services: AppServices
    private let coordinator: AppCoordinator

    var shareText: String {
        """
        🏆 \(achievement.title)
        📅 \(formatDate(achievement.date))
        📂 \(achievement.category.icon) \(achievement.category.rawValue)
        ⭐ Impact: \(achievement.impactScore)/5
        \(achievement.description.map { "\n📝 \($0)" } ?? "")
        """
    }

    var sharePreviewStreak: Int {
        services.statsEngine.loadStats().currentStreak
    }

    var weeklyInsight: String {
        services.statsEngine.moodInsights().first?.message ?? "Every small win counts."
    }

    init(achievement: Achievement,
         services: AppServices,
         coordinator: AppCoordinator) {
        self.achievement = achievement
        self.services = services
        self.coordinator = coordinator
    }

    func toggleFavorite() {
        var updated = achievement
        updated.isFavorite.toggle()
        achievement = updated
        services.storageService.update(updated, forKey: StorageKeys.achievements)
    }

    func deleteAchievement() {
        var allAchievements: [Achievement] = services.storageService.load(forKey: StorageKeys.achievements)
        allAchievements.removeAll { $0.id == achievement.id }
        services.storageService.save(allAchievements, forKey: StorageKeys.achievements)
        _ = services.statsEngine.recalculateAndSave()
        coordinator.pop()
    }

    func goToEdit() {
        coordinator.navigateToAchievementForm(achievement: achievement)
    }

    func goBack() {
        coordinator.pop()
    }

    func shareAchievement() {
        let stats = services.statsEngine.loadStats()
        if let image = InsightShareCardRenderer.renderImage(
            title: achievement.title,
            category: achievement.category,
            streak: stats.currentStreak,
            insight: weeklyInsight,
            impactScore: achievement.impactScore
        ) {
            shareItems = [image, shareText]
        } else {
            shareItems = [shareText]
        }
        showShareSheet = true
    }

    func formatDate(_ date: Date) -> String {
        DateFormatter.achievementDate.string(from: date)
    }
}
