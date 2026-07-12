import Foundation

enum MilestoneType: String, Codable, CaseIterable, Hashable {
    case firstWin
    case sevenDayAwareness
    case twentyFiveWins
    case balancedWeek
    case firstRitual
    case tenRituals
    case highImpactWeek

    var title: String {
        switch self {
        case .firstWin: return "First Win"
        case .sevenDayAwareness: return "7-Day Awareness"
        case .twentyFiveWins: return "25 Wins Logged"
        case .balancedWeek: return "Balanced Week"
        case .firstRitual: return "First Ritual"
        case .tenRituals: return "10 Rituals Done"
        case .highImpactWeek: return "High Impact Week"
        }
    }

    var description: String {
        switch self {
        case .firstWin: return "Logged your very first win"
        case .sevenDayAwareness: return "Completed 7 daily rituals"
        case .twentyFiveWins: return "Reached 25 total wins"
        case .balancedWeek: return "Wins in 3+ categories this week"
        case .firstRitual: return "Finished your first daily ritual"
        case .tenRituals: return "Completed 10 daily rituals"
        case .highImpactWeek: return "Average impact score 4+ this week"
        }
    }

    var icon: String {
        switch self {
        case .firstWin: return "🎯"
        case .sevenDayAwareness: return "🔥"
        case .twentyFiveWins: return "🏆"
        case .balancedWeek: return "⚖️"
        case .firstRitual: return "✨"
        case .tenRituals: return "🌟"
        case .highImpactWeek: return "💎"
        }
    }
}

struct Milestone: Identifiable, Codable, Hashable {
    let id: UUID
    let type: MilestoneType
    let unlockedAt: Date
}
