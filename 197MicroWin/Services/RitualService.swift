import Foundation

final class RitualService {
    private let storageService: StorageServiceProtocol
    private let statsEngine: StatsEngine
    private let milestoneService: MilestoneService

    init(storageService: StorageServiceProtocol, statsEngine: StatsEngine, milestoneService: MilestoneService) {
        self.storageService = storageService
        self.statsEngine = statsEngine
        self.milestoneService = milestoneService
    }

    func hasCompletedToday() -> Bool {
        statsEngine.hasCompletedRitualToday()
    }

    func completeRitual(
        primaryTitle: String,
        primaryCategory: Category,
        microTitle: String?,
        microCategory: Category?,
        reflection: String,
        mood: Mood,
        winSize: WinSize,
        energy: EnergyLevel,
        impactScore: Int
    ) {
        let now = Date()
        let primaryId = UUID()
        let primary = Achievement(
            id: primaryId,
            title: primaryTitle,
            description: nil,
            category: primaryCategory,
            date: now,
            isFavorite: false,
            createdAt: now,
            winSize: winSize,
            energy: energy,
            impactScore: impactScore,
            mood: mood,
            reflectionNote: reflection.isEmpty ? nil : reflection,
            fromRitual: true,
            isMicroWin: false
        )
        storageService.append(primary, forKey: StorageKeys.achievements)

        var microId: UUID?
        if let microTitle, !microTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let id = UUID()
            microId = id
            let micro = Achievement(
                id: id,
                title: microTitle,
                description: nil,
                category: microCategory ?? primaryCategory,
                date: now,
                isFavorite: false,
                createdAt: now,
                winSize: .tiny,
                energy: energy,
                impactScore: max(1, impactScore - 1),
                mood: mood,
                reflectionNote: nil,
                fromRitual: true,
                isMicroWin: true
            )
            storageService.append(micro, forKey: StorageKeys.achievements)
        }

        let session = RitualSession(
            id: UUID(),
            date: now,
            primaryWinId: primaryId,
            microWinId: microId,
            completedAt: now
        )
        storageService.append(session, forKey: StorageKeys.ritualSessions)

        _ = statsEngine.recalculateAndSave()
        _ = milestoneService.evaluateAndUnlock()
    }
}
