import Foundation

enum WinSize: String, Codable, CaseIterable, Hashable {
    case tiny = "Tiny"
    case small = "Small"
    case medium = "Medium"

    var icon: String {
        switch self {
        case .tiny: return "🌱"
        case .small: return "⭐"
        case .medium: return "🔥"
        }
    }
}

enum EnergyLevel: String, Codable, CaseIterable, Hashable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var icon: String {
        switch self {
        case .low: return "🔋"
        case .medium: return "⚡"
        case .high: return "🚀"
        }
    }
}

enum Mood: String, Codable, CaseIterable, Hashable {
    case calm = "Calm"
    case motivated = "Motivated"
    case tired = "Tired"
    case proud = "Proud"
    case stressed = "Stressed"

    var icon: String {
        switch self {
        case .calm: return "😌"
        case .motivated: return "💪"
        case .tired: return "😴"
        case .proud: return "😊"
        case .stressed: return "😤"
        }
    }

    var color: String {
        switch self {
        case .calm: return "#74B9FF"
        case .motivated: return "#4CAF50"
        case .tired: return "#8899AA"
        case .proud: return "#FFD93D"
        case .stressed: return "#FF6B6B"
        }
    }
}
