import SwiftUI
import Combine
import StoreKit

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var showResetAlert = false

    private let services: AppServices
    private let coordinator: AppCoordinator

    init(services: AppServices, coordinator: AppCoordinator) {
        self.services = services
        self.coordinator = coordinator
    }

    func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }

    func openPrivacyPolicy() {
        openLink(.privacyPolicy)
    }

    func openTermsOfUse() {
        openLink(.termsOfUse)
    }

    private func openLink(_ link: AppLinks) {
        if let url = link.url {
            UIApplication.shared.open(url)
        }
    }

    func resetAllData() {
        let storage = services.storageService
        storage.delete(forKey: StorageKeys.achievements)
        storage.delete(forKey: StorageKeys.stats)
        storage.delete(forKey: StorageKeys.quotes)
        storage.delete(forKey: StorageKeys.templates)
        storage.delete(forKey: StorageKeys.personalPhrases)
        storage.delete(forKey: StorageKeys.weeklyReflections)
        storage.delete(forKey: StorageKeys.focusAreas)
        storage.delete(forKey: StorageKeys.milestones)
        storage.delete(forKey: StorageKeys.ritualSessions)
        coordinator.popToRoot()
    }

    func goBack() {
        coordinator.pop()
    }
}
