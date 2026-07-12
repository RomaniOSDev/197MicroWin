import Foundation

enum Category: String, CaseIterable, Codable {
    case work = "Work"
    case health = "Health"
    case relationships = "Relationships"
    case hobby = "Hobby"
    case personal = "Personal"
    case finance = "Finance"
    case learning = "Learning"
    case fitness = "Fitness"
    case home = "Home"
    case other = "Other"

    var icon: String {
        switch self {
        case .work: return "💼"
        case .health: return "💪"
        case .relationships: return "❤️"
        case .hobby: return "🎨"
        case .personal: return "🧠"
        case .finance: return "💰"
        case .learning: return "📚"
        case .fitness: return "🏃"
        case .home: return "🏠"
        case .other: return "🌟"
        }
    }

    var color: String {
        switch self {
        case .work: return "#0277DB"
        case .health: return "#4CAF50"
        case .relationships: return "#FF6B6B"
        case .hobby: return "#FFD93D"
        case .personal: return "#A29BFE"
        case .finance: return "#00B894"
        case .learning: return "#FDCB6E"
        case .fitness: return "#E17055"
        case .home: return "#74B9FF"
        case .other: return "#6C5CE7"
        }
    }
}
