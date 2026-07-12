import SwiftUI
import Combine

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published var stats: Stats = .empty
    @Published var achievements: [Achievement] = []

    private let services: AppServices
    private let coordinator: AppCoordinator

    var categoryData: [(Category, Int)] {
        stats.achievementsByCategory.sorted { $0.value > $1.value }
    }

    init(services: AppServices, coordinator: AppCoordinator) {
        self.services = services
        self.coordinator = coordinator
        loadData()
    }

    func loadData() {
        achievements = services.statsEngine.achievements()
        stats = services.statsEngine.recalculateAndSave()
    }

    func goToMoodInsights() {
        coordinator.navigateToMoodInsights()
    }

    func goBack() {
        coordinator.pop()
    }
}
