import SwiftUI
import Combine

@MainActor
final class MilestonesViewModel: ObservableObject {
    @Published var unlocked: [Milestone] = []
    @Published var allTypes: [MilestoneType] = MilestoneType.allCases

    private let services: AppServices
    private let coordinator: AppCoordinator

    init(services: AppServices, coordinator: AppCoordinator) {
        self.services = services
        self.coordinator = coordinator
        load()
    }

    func load() {
        _ = services.milestoneService.evaluateAndUnlock()
        unlocked = services.milestoneService.getMilestones().sorted { $0.unlockedAt > $1.unlockedAt }
    }

    func isUnlocked(_ type: MilestoneType) -> Bool {
        unlocked.contains { $0.type == type }
    }

    func progress(for type: MilestoneType) -> Double {
        services.milestoneService.progress(for: type)
    }

    func goBack() {
        coordinator.pop()
    }
}
