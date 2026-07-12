import Foundation

struct WinTemplate: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var category: Category
    var isCustom: Bool
}

extension WinTemplate {
    static let defaults: [WinTemplate] = [
        WinTemplate(id: UUID(), title: "Finished a workout", category: .fitness, isCustom: false),
        WinTemplate(id: UUID(), title: "Had a hard conversation", category: .relationships, isCustom: false),
        WinTemplate(id: UUID(), title: "Didn't procrastinate on a task", category: .work, isCustom: false),
        WinTemplate(id: UUID(), title: "Cooked a healthy meal", category: .health, isCustom: false),
        WinTemplate(id: UUID(), title: "Learned something new", category: .learning, isCustom: false),
        WinTemplate(id: UUID(), title: "Took time for myself", category: .personal, isCustom: false),
        WinTemplate(id: UUID(), title: "Organized my space", category: .home, isCustom: false),
        WinTemplate(id: UUID(), title: "Stuck to my budget", category: .finance, isCustom: false)
    ]
}
