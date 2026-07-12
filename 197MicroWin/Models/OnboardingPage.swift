import SwiftUI

struct OnboardingPage: Identifiable {
    let id: Int
    let systemIcon: String
    let imageName: String?
    let tint: Color
    let title: String
    let subtitle: String

    static let all: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            systemIcon: "trophy.fill",
            imageName: HomeAsset.heroRitual,
            tint: AppColor.accent,
            title: "Track Every Win",
            subtitle: "Capture small wins before they slip away. Build a habit of noticing progress every day."
        ),
        OnboardingPage(
            id: 1,
            systemIcon: "sparkles",
            imageName: HomeAsset.widgetStreak,
            tint: Color(hex: "6C5CE7"),
            title: "Start Your Daily Ritual",
            subtitle: "Begin each morning with intention. Log mood, energy, and impact in a mindful flow."
        ),
        OnboardingPage(
            id: 2,
            systemIcon: "chart.line.uptrend.xyaxis",
            imageName: HomeAsset.widgetProgress,
            tint: Color(hex: "4CAF50"),
            title: "See Your Growth",
            subtitle: "Heatmaps, badges, focus areas, and weekly reflections help you stay consistent."
        )
    ]
}
