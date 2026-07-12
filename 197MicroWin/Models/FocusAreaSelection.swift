import Foundation

struct FocusAreaSelection: Codable, Hashable {
    var monthKey: String
    var categories: [Category]

    static func currentMonthKey(for date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: date)
    }
}
