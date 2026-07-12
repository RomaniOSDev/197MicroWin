import Foundation

enum AppRoute: Hashable {
    case dailyRitual
    case achievementList(category: Category?)
    case achievementForm(achievement: Achievement?)
    case achievementDetail(achievement: Achievement)
    case categories
    case statistics
    case personalMotivation
    case settings
    case calendar
    case weeklyReflection
    case moodInsights
    case templates
    case milestones
    case focusAreas
}
