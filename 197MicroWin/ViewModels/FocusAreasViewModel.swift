import SwiftUI
import Combine

@MainActor
final class FocusAreasViewModel: ObservableObject {
    @Published var selectedCategories: Set<Category> = []
    @Published var progressMap: [Category: Int] = [:]
    @Published var neglected: [Category] = []

    private let services: AppServices
    private let coordinator: AppCoordinator

    init(services: AppServices, coordinator: AppCoordinator) {
        self.services = services
        self.coordinator = coordinator
        load()
    }

    func load() {
        let selection = services.focusAreaService.currentSelection()
        selectedCategories = Set(selection.categories)
        progressMap = Dictionary(uniqueKeysWithValues: selection.categories.map { ($0, services.focusAreaService.progress(for: $0)) })
        neglected = services.focusAreaService.neglectedAreas()
    }

    func toggle(_ category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else if selectedCategories.count < 3 {
            selectedCategories.insert(category)
        }
    }

    func save() {
        services.focusAreaService.saveSelection(Array(selectedCategories))
        load()
    }

    func goBack() {
        coordinator.pop()
    }
}
