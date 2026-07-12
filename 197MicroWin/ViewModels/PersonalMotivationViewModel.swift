import SwiftUI
import Combine

@MainActor
final class PersonalMotivationViewModel: ObservableObject {
    @Published var phrases: [PersonalPhrase] = []
    @Published var newPhrase = ""
    @Published var contextualMessage: String?

    private let services: AppServices
    private let coordinator: AppCoordinator

    init(services: AppServices, coordinator: AppCoordinator) {
        self.services = services
        self.coordinator = coordinator
        load()
    }

    func load() {
        phrases = services.personalMotivationService.getPhrases()
        contextualMessage = services.personalMotivationService.contextualMessage()
    }

    func addPhrase() {
        let text = newPhrase.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        services.personalMotivationService.addPhrase(text)
        newPhrase = ""
        load()
    }

    func delete(_ phrase: PersonalPhrase) {
        services.personalMotivationService.deletePhrase(phrase)
        load()
    }

    func goBack() {
        coordinator.pop()
    }
}
