import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var stats: Stats = .empty
    @Published var recentAchievements: [Achievement] = []
    @Published var personalMessage: String?
    @Published var focusAreas: [Category] = []
    @Published var focusProgress: [Category: Int] = [:]
    @Published var neglectedAreas: [Category] = []
    @Published var showWeeklyReflectionPrompt = false
    @Published var ritualCompletedToday = false
    @Published var newlyUnlockedMilestones: [Milestone] = []

    private let services: AppServices
    private let coordinator: AppCoordinator

    var totalAchievements: Int { stats.totalAchievements }
    var streakDays: Int { stats.currentStreak }
    var favoriteCategory: Category? { stats.favoriteCategory }
    var averageImpact: String { String(format: "%.1f", stats.averageImpactScore) }
    var weekWins: Int { stats.achievementsThisWeek }
    var ritualDays: Int { stats.ritualDaysCompleted }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }

    var greetingSubtitle: String {
        if ritualCompletedToday {
            return "You've completed today's ritual — nice work"
        }
        if totalAchievements == 0 {
            return "Ready to log your first small win?"
        }
        return "Small wins every day"
    }

    var latestMilestone: Milestone? {
        newlyUnlockedMilestones.sorted { $0.unlockedAt > $1.unlockedAt }.first
    }

    init(services: AppServices, coordinator: AppCoordinator) {
        self.services = services
        self.coordinator = coordinator
        loadData()
    }

    func loadData() {
        achievements = services.statsEngine.achievements()
        stats = services.statsEngine.recalculateAndSave()
        recentAchievements = Array(achievements.sorted { $0.date > $1.date }.prefix(5))
        personalMessage = services.personalMotivationService.contextualMessage()
        ritualCompletedToday = services.ritualService.hasCompletedToday()

        let selection = services.focusAreaService.currentSelection()
        focusAreas = selection.categories
        focusProgress = Dictionary(uniqueKeysWithValues: focusAreas.map { ($0, services.focusAreaService.progress(for: $0)) })
        neglectedAreas = services.focusAreaService.neglectedAreas()

        showWeeklyReflectionPrompt = services.weeklyReflectionService.isDue()
        newlyUnlockedMilestones = services.milestoneService.evaluateAndUnlock()
    }

    func goToDailyRitual() { coordinator.navigateToDailyRitual() }
    func goToAchievementList(category: Category? = nil) { coordinator.navigateToAchievementList(category: category) }
    func goToAchievementForm() { coordinator.navigateToAchievementForm() }
    func goToAchievementDetail(_ achievement: Achievement) { coordinator.navigateToAchievementDetail(achievement: achievement) }
    func goToCategories() { coordinator.navigateToCategories() }
    func goToStatistics() { coordinator.navigateToStatistics() }
    func goToPersonalMotivation() { coordinator.navigateToPersonalMotivation() }
    func goToSettings() { coordinator.navigateToSettings() }
    func goToCalendar() { coordinator.navigateToCalendar() }
    func goToWeeklyReflection() { coordinator.navigateToWeeklyReflection() }
    func goToMoodInsights() { coordinator.navigateToMoodInsights() }
    func goToTemplates() { coordinator.navigateToTemplates() }
    func goToMilestones() { coordinator.navigateToMilestones() }
    func goToFocusAreas() { coordinator.navigateToFocusAreas() }
}
