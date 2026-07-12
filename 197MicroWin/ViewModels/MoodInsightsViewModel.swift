import SwiftUI
import Combine

@MainActor
final class MoodInsightsViewModel: ObservableObject {
    @Published var insights: [MoodInsight] = []
    @Published var stats: Stats = .empty

    private let services: AppServices
    private let coordinator: AppCoordinator

    init(services: AppServices, coordinator: AppCoordinator) {
        self.services = services
        self.coordinator = coordinator
        loadData()
    }

    func loadData() {
        stats = services.statsEngine.recalculateAndSave()
        insights = services.statsEngine.moodInsights()
    }

    func goBack() {
        coordinator.pop()
    }
}
