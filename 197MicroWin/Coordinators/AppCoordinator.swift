import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published var hasCompletedOnboarding: Bool

    let services: AppServices

    init(services: AppServices) {
        self.services = services
        self.hasCompletedOnboarding = services.onboardingService.hasCompletedOnboarding
    }

    func start() -> some View {
        _ = services.templateService.getTemplates()
        _ = services.statsEngine.recalculateAndSave()

        return AppRootView(coordinator: self)
    }

    func finishOnboarding() {
        hasCompletedOnboarding = true
    }

    func navigateToDailyRitual() {
        path.append(.dailyRitual)
    }

    func navigateToAchievementList(category: Category? = nil) {
        path.append(.achievementList(category: category))
    }

    func navigateToAchievementForm(achievement: Achievement? = nil) {
        path.append(.achievementForm(achievement: achievement))
    }

    func navigateToAchievementDetail(achievement: Achievement) {
        path.append(.achievementDetail(achievement: achievement))
    }

    func navigateToCategories() {
        path.append(.categories)
    }

    func navigateToStatistics() {
        path.append(.statistics)
    }

    func navigateToPersonalMotivation() {
        path.append(.personalMotivation)
    }

    func navigateToSettings() {
        path.append(.settings)
    }

    func navigateToCalendar() {
        path.append(.calendar)
    }

    func navigateToWeeklyReflection() {
        path.append(.weeklyReflection)
    }

    func navigateToMoodInsights() {
        path.append(.moodInsights)
    }

    func navigateToTemplates() {
        path.append(.templates)
    }

    func navigateToMilestones() {
        path.append(.milestones)
    }

    func navigateToFocusAreas() {
        path.append(.focusAreas)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = []
    }

    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        switch route {
        case .dailyRitual:
            DailyRitualView(viewModel: DailyRitualViewModel(services: services, coordinator: self))
        case let .achievementList(category):
            AchievementListView(viewModel: AchievementListViewModel(
                category: category,
                storageService: services.storageService,
                coordinator: self
            ))
        case let .achievementForm(achievement):
            AchievementFormView(viewModel: AchievementFormViewModel(
                achievement: achievement,
                services: services,
                coordinator: self
            ))
        case let .achievementDetail(achievement):
            AchievementDetailView(viewModel: AchievementDetailViewModel(
                achievement: achievement,
                services: services,
                coordinator: self
            ))
        case .categories:
            CategoriesView(viewModel: CategoriesViewModel(
                storageService: services.storageService,
                coordinator: self
            ))
        case .statistics:
            StatisticsView(viewModel: StatisticsViewModel(
                services: services,
                coordinator: self
            ))
        case .personalMotivation:
            PersonalMotivationView(viewModel: PersonalMotivationViewModel(services: services, coordinator: self))
        case .settings:
            SettingsView(viewModel: SettingsViewModel(
                services: services,
                coordinator: self
            ))
        case .calendar:
            CalendarHeatmapView(viewModel: CalendarHeatmapViewModel(services: services, coordinator: self))
        case .weeklyReflection:
            WeeklyReflectionScreen(viewModel: WeeklyReflectionViewModel(services: services, coordinator: self))
        case .moodInsights:
            MoodInsightsView(viewModel: MoodInsightsViewModel(services: services, coordinator: self))
        case .templates:
            TemplatesView(viewModel: TemplatesViewModel(services: services, coordinator: self))
        case .milestones:
            MilestonesView(viewModel: MilestonesViewModel(services: services, coordinator: self))
        case .focusAreas:
            FocusAreasView(viewModel: FocusAreasViewModel(services: services, coordinator: self))
        }
    }
}

struct AppRootView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var homeViewModel: HomeViewModel

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(
            services: coordinator.services,
            coordinator: coordinator
        ))
    }

    var body: some View {
        Group {
            if coordinator.hasCompletedOnboarding {
                HomeView(viewModel: homeViewModel, coordinator: coordinator)
            } else {
                OnboardingView(viewModel: OnboardingViewModel(
                    onboardingService: coordinator.services.onboardingService,
                    onComplete: coordinator.finishOnboarding
                ))
            }
        }
    }
}
