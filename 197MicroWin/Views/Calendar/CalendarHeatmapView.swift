import SwiftUI

struct CalendarHeatmapView: View {
    @StateObject private var viewModel: CalendarHeatmapViewModel

    init(viewModel: CalendarHeatmapViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AppScrollScreen {
            VStack(spacing: AppLayout.sectionSpacing) {
                AppScreenTitleBar(emoji: "📅", title: "Win Calendar")

                HStack {
                    Button(action: viewModel.previousMonth) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.title2)
                            .foregroundColor(AppColor.accent)
                    }
                    Spacer()
                    Button(action: viewModel.nextMonth) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.title2)
                            .foregroundColor(AppColor.accent)
                    }
                }

                CalendarHeatmapComponent(
                    month: viewModel.selectedMonth,
                    daysWithWins: viewModel.daysWithWins,
                    onDayTap: viewModel.selectDay
                )

                if let date = viewModel.selectedDate {
                    VStack(spacing: 12) {
                        AppSectionHeader(
                            title: DateFormatter.achievementDate.string(from: date)
                        )

                        if viewModel.selectedDayWins.isEmpty {
                            EmptyStateView(
                                icon: "📭",
                                title: "No Wins",
                                message: "Nothing logged on this day",
                                buttonTitle: "",
                                action: {}
                            )
                        } else {
                            ForEach(viewModel.selectedDayWins) { win in
                                AchievementCardView(achievement: win) {
                                    viewModel.goToDetail(win)
                                }
                            }
                        }
                    }
                }
            }
        }
        .appPushedScreen(onBack: viewModel.goBack)
        .onAppear { viewModel.loadMonth() }
    }
}
