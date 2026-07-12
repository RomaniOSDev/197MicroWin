import SwiftUI
import Combine

@MainActor
final class AchievementFormViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var selectedCategory: Category = .personal
    @Published var date = Date()
    @Published var isFavorite = false
    @Published var winSize: WinSize = .small
    @Published var energy: EnergyLevel = .medium
    @Published var impactScore = 3
    @Published var selectedMood: Mood?
    @Published var reflectionNote = ""
    @Published var templates: [WinTemplate] = []

    private let services: AppServices
    private let coordinator: AppCoordinator
    private let editingAchievement: Achievement?

    var isEditing: Bool { editingAchievement != nil }

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(achievement: Achievement? = nil,
         services: AppServices,
         coordinator: AppCoordinator) {
        self.editingAchievement = achievement
        self.services = services
        self.coordinator = coordinator
        templates = services.templateService.getTemplates()

        if let achievement {
            title = achievement.title
            description = achievement.description ?? ""
            selectedCategory = achievement.category
            date = achievement.date
            isFavorite = achievement.isFavorite
            winSize = achievement.winSize
            energy = achievement.energy
            impactScore = achievement.impactScore
            selectedMood = achievement.mood
            reflectionNote = achievement.reflectionNote ?? ""
        }
    }

    func applyTemplate(_ template: WinTemplate) {
        title = template.title
        selectedCategory = template.category
    }

    func saveAchievement() {
        guard isFormValid else { return }

        if isEditing, let achievement = editingAchievement {
            var updated = achievement
            updated.title = title
            updated.description = description.isEmpty ? nil : description
            updated.category = selectedCategory
            updated.date = date
            updated.isFavorite = isFavorite
            updated.winSize = winSize
            updated.energy = energy
            updated.impactScore = impactScore
            updated.mood = selectedMood
            updated.reflectionNote = reflectionNote.isEmpty ? nil : reflectionNote
            services.storageService.update(updated, forKey: StorageKeys.achievements)
        } else {
            let newAchievement = Achievement(
                id: UUID(),
                title: title,
                description: description.isEmpty ? nil : description,
                category: selectedCategory,
                date: date,
                isFavorite: isFavorite,
                createdAt: Date(),
                winSize: winSize,
                energy: energy,
                impactScore: impactScore,
                mood: selectedMood,
                reflectionNote: reflectionNote.isEmpty ? nil : reflectionNote
            )
            services.storageService.append(newAchievement, forKey: StorageKeys.achievements)
        }

        _ = services.statsEngine.recalculateAndSave()
        _ = services.milestoneService.evaluateAndUnlock()
        coordinator.pop()
    }

    func cancel() {
        coordinator.pop()
    }
}
