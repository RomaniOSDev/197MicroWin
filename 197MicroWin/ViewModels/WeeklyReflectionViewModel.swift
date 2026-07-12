import SwiftUI
import Combine

@MainActor
final class WeeklyReflectionViewModel: ObservableObject {
    @Published var topWins: [Achievement] = []
    @Published var mostActiveCategory: Category?
    @Published var patternNote = ""
    @Published var intention = ""

    private let services: AppServices
    private let coordinator: AppCoordinator

    var isValid: Bool {
        !patternNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !intention.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(services: AppServices, coordinator: AppCoordinator) {
        self.services = services
        self.coordinator = coordinator
        loadData()
    }

    func loadData() {
        topWins = services.statsEngine.topWinsThisWeek()
        mostActiveCategory = services.statsEngine.mostActiveCategoryThisWeek()
    }

    func save() {
        services.weeklyReflectionService.saveReflection(
            patternNote: patternNote.trimmingCharacters(in: .whitespacesAndNewlines),
            intention: intention.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        coordinator.pop()
    }

    func goBack() {
        coordinator.pop()
    }
}
