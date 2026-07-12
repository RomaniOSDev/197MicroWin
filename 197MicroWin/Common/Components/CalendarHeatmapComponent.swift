import SwiftUI

struct CalendarHeatmapComponent: View {
    let month: Date
    let daysWithWins: Set<Date>
    let onDayTap: (Date) -> Void

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)

    var body: some View {
        VStack(spacing: 14) {
            Text(monthTitle)
                .font(.headline.weight(.semibold))
                .foregroundColor(AppColor.textPrimary)

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2.weight(.bold))
                        .foregroundColor(AppColor.textSecondary)
                }

                ForEach(dayCells, id: \.self) { cell in
                    if let date = cell {
                        DayCell(
                            day: calendar.component(.day, from: date),
                            hasWin: daysWithWins.contains(calendar.startOfDay(for: date)),
                            isToday: calendar.isDateInToday(date)
                        ) {
                            onDayTap(date)
                        }
                    } else {
                        Color.clear.frame(height: 38)
                    }
                }
            }
        }
        .padding(16)
        .appFloatingCard(tint: AppColor.accent)
    }

    private var monthTitle: String {
        DateFormatter.monthYear.string(from: month)
    }

    private var weekdaySymbols: [String] {
        calendar.shortWeekdaySymbols
    }

    private var dayCells: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let leadingEmpty = (firstWeekday - calendar.firstWeekday + 7) % 7
        var cells: [Date?] = Array(repeating: nil, count: leadingEmpty)

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                cells.append(date)
            }
        }
        return cells
    }
}

private struct DayCell: View {
    let day: Int
    let hasWin: Bool
    let isToday: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(day)")
                .font(.caption.weight(.semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            hasWin
                                ? AnyShapeStyle(AppGradient.progressFill)
                                : AnyShapeStyle(AppColor.background.opacity(0.45))
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(isToday ? AppColor.accent : (hasWin ? AppColor.accent.opacity(0.5) : Color.clear), lineWidth: isToday ? 2 : 1)
                )
                .foregroundColor(hasWin ? AppColor.textPrimary : AppColor.textSecondary)
        }
        .buttonStyle(.plain)
    }
}
