import Foundation

struct Quote: Identifiable, Codable {
    let id: UUID
    let text: String
    let author: String
    let category: Category?
    var isUsed: Bool
}

extension Quote {
    static let defaultQuotes: [Quote] = [
        Quote(id: UUID(), text: "Small wins lead to big achievements", author: "John Maxwell", category: nil, isUsed: false),
        Quote(id: UUID(), text: "Every day is a new opportunity to change your life", author: "Tony Robbins", category: nil, isUsed: false),
        Quote(id: UUID(), text: "Success is the sum of small efforts repeated day in and day out", author: "Robert Collier", category: nil, isUsed: false),
        Quote(id: UUID(), text: "Celebrate every small win on the path to a big goal", author: "Unknown", category: nil, isUsed: false),
        Quote(id: UUID(), text: "Great things are done by a series of small steps", author: "Confucius", category: nil, isUsed: false),
        Quote(id: UUID(), text: "Today I did more than yesterday — that's already a win", author: "Unknown", category: .personal, isUsed: false),
        Quote(id: UUID(), text: "A small step forward is still a step forward", author: "Unknown", category: .fitness, isUsed: false),
        Quote(id: UUID(), text: "Every achievement begins with the decision to try", author: "Unknown", category: .work, isUsed: false),
        Quote(id: UUID(), text: "You are stronger than you think. You are capable of more than you imagine", author: "Unknown", category: .personal, isUsed: false),
        Quote(id: UUID(), text: "Small wins are fuel for great accomplishments", author: "Unknown", category: nil, isUsed: false),
        Quote(id: UUID(), text: "If you do something every day, you become a master of it", author: "Robert Greene", category: .learning, isUsed: false),
        Quote(id: UUID(), text: "A journey of a thousand miles begins with a single step", author: "Lao Tzu", category: nil, isUsed: false)
    ]
}
