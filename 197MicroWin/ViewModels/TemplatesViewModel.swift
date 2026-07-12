import SwiftUI
import Combine

@MainActor
final class TemplatesViewModel: ObservableObject {
    @Published var templates: [WinTemplate] = []
    @Published var newTitle = ""
    @Published var newCategory: Category = .personal

    private let services: AppServices
    private let coordinator: AppCoordinator

    var canAdd: Bool {
        !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(services: AppServices, coordinator: AppCoordinator) {
        self.services = services
        self.coordinator = coordinator
        load()
    }

    func load() {
        templates = services.templateService.getTemplates()
    }

    func addTemplate() {
        guard canAdd else { return }
        services.templateService.addTemplate(
            title: newTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            category: newCategory
        )
        newTitle = ""
        load()
    }

    func delete(_ template: WinTemplate) {
        guard template.isCustom else { return }
        services.templateService.deleteTemplate(template)
        load()
    }

    func goBack() {
        coordinator.pop()
    }
}
