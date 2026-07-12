import SwiftUI
import Combine

@MainActor
final class DailyRitualViewModel: ObservableObject {
    enum Step: Int, CaseIterable {
        case primaryWin
        case microWin
        case reflection
        case moodAndMetrics
        case completion
    }

    @Published var step: Step = .primaryWin
    @Published var primaryTitle = ""
    @Published var primaryCategory: Category = .personal
    @Published var microTitle = ""
    @Published var microCategory: Category = .personal
    @Published var reflection = ""
    @Published var selectedMood: Mood?
    @Published var winSize: WinSize = .small
    @Published var energy: EnergyLevel = .medium
    @Published var impactScore = 3
    @Published var templates: [WinTemplate] = []

    private let services: AppServices
    private let coordinator: AppCoordinator

    var progress: Double {
        Double(step.rawValue) / Double(Step.allCases.count - 1)
    }

    var isPrimaryValid: Bool {
        !primaryTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isReadyToComplete: Bool {
        isPrimaryValid && selectedMood != nil
    }

    var streakAfterCompletion: Int {
        services.statsEngine.loadStats().currentStreak
    }

    init(services: AppServices, coordinator: AppCoordinator) {
        self.services = services
        self.coordinator = coordinator
        templates = services.templateService.getTemplates()
    }

    func applyTemplate(_ template: WinTemplate, toPrimary: Bool) {
        if toPrimary {
            primaryTitle = template.title
            primaryCategory = template.category
        } else {
            microTitle = template.title
            microCategory = template.category
        }
    }

    func nextStep() {
        guard let next = Step(rawValue: step.rawValue + 1) else { return }
        step = next
    }

    func previousStep() {
        guard step != .primaryWin, let prev = Step(rawValue: step.rawValue - 1) else { return }
        step = prev
    }

    func completeRitual() {
        guard let mood = selectedMood else { return }
        services.ritualService.completeRitual(
            primaryTitle: primaryTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            primaryCategory: primaryCategory,
            microTitle: microTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : microTitle,
            microCategory: microCategory,
            reflection: reflection,
            mood: mood,
            winSize: winSize,
            energy: energy,
            impactScore: impactScore
        )
        step = .completion
    }

    func finish() {
        coordinator.pop()
    }

    func cancel() {
        coordinator.pop()
    }
}
