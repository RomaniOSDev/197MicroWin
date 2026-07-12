import Foundation

final class OnboardingService {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var hasCompletedOnboarding: Bool {
        defaults.bool(forKey: StorageKeys.hasCompletedOnboarding)
    }

    func markOnboardingCompleted() {
        defaults.set(true, forKey: StorageKeys.hasCompletedOnboarding)
    }
}
