import Foundation

final class AppServices {
    let storageService: StorageServiceProtocol
    let statsEngine: StatsEngine
    let templateService: TemplateService
    let personalMotivationService: PersonalMotivationService
    let milestoneService: MilestoneService
    let focusAreaService: FocusAreaService
    let ritualService: RitualService
    let weeklyReflectionService: WeeklyReflectionService
    let onboardingService: OnboardingService

    init(storageService: StorageServiceProtocol = UserDefaultsStorageService()) {
        self.storageService = storageService
        self.statsEngine = StatsEngine(storageService: storageService)
        self.templateService = TemplateService(storageService: storageService)
        self.personalMotivationService = PersonalMotivationService(storageService: storageService, statsEngine: statsEngine)
        self.milestoneService = MilestoneService(storageService: storageService, statsEngine: statsEngine)
        self.focusAreaService = FocusAreaService(storageService: storageService, statsEngine: statsEngine)
        self.ritualService = RitualService(storageService: storageService, statsEngine: statsEngine, milestoneService: milestoneService)
        self.weeklyReflectionService = WeeklyReflectionService(storageService: storageService, statsEngine: statsEngine)
        self.onboardingService = OnboardingService()
    }
}
