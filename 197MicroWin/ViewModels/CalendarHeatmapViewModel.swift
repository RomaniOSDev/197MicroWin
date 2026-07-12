import SwiftUI
import Combine

@MainActor
final class CalendarHeatmapViewModel: ObservableObject {
    @Published var selectedMonth = Date()
    @Published var daysWithWins: Set<Date> = []
    @Published var selectedDayWins: [Achievement] = []
    @Published var selectedDate: Date?

    private let services: AppServices
    private let coordinator: AppCoordinator

    init(services: AppServices, coordinator: AppCoordinator) {
        self.services = services
        self.coordinator = coordinator
        loadMonth()
    }

    func loadMonth() {
        daysWithWins = services.statsEngine.daysWithWins(in: selectedMonth)
        if let selectedDate {
            selectedDayWins = services.statsEngine.wins(for: selectedDate)
        }
    }

    func selectDay(_ date: Date) {
        selectedDate = date
        selectedDayWins = services.statsEngine.wins(for: date)
    }

    func previousMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
        selectedDate = nil
        selectedDayWins = []
        loadMonth()
    }

    func nextMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
        selectedDate = nil
        selectedDayWins = []
        loadMonth()
    }

    func goToDetail(_ achievement: Achievement) {
        coordinator.navigateToAchievementDetail(achievement: achievement)
    }

    func goBack() {
        coordinator.pop()
    }
}
