import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0

    let pages = OnboardingPage.all

    private let onboardingService: OnboardingService
    private let onComplete: () -> Void

    init(onboardingService: OnboardingService, onComplete: @escaping () -> Void) {
        self.onboardingService = onboardingService
        self.onComplete = onComplete
    }

    var isLastPage: Bool {
        currentPage >= pages.count - 1
    }

    var primaryButtonTitle: String {
        isLastPage ? "Get Started" : "Continue"
    }

    var primaryButtonIcon: String {
        isLastPage ? "arrow.right.circle.fill" : "arrow.right"
    }

    func advance() {
        if isLastPage {
            finish()
        } else {
            withAnimation(.easeInOut(duration: 0.25)) {
                currentPage += 1
            }
        }
    }

    func skip() {
        finish()
    }

    private func finish() {
        onboardingService.markOnboardingCompleted()
        onComplete()
    }
}
