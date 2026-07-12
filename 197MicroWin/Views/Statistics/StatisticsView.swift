import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel: StatisticsViewModel

    init(viewModel: StatisticsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AppScrollScreen {
            VStack(spacing: AppLayout.sectionSpacing) {
                AppScreenTitleBar(emoji: "📊", title: "Statistics")

                HStack(spacing: 10) {
                    StatMetricCell(value: "\(viewModel.stats.totalAchievements)", label: "Total Wins", icon: "trophy.fill", tint: AppColor.accent)
                    StatMetricCell(value: "\(viewModel.stats.currentStreak)", label: "Day Streak", icon: "flame.fill", tint: Color(hex: "4CAF50"))
                    StatMetricCell(value: "\(viewModel.stats.maxStreak)", label: "Best Streak", icon: "crown.fill", tint: Color(hex: "FFD93D"))
                }

                HStack(spacing: 10) {
                    StatMetricCell(
                        value: String(format: "%.1f", viewModel.stats.averageImpactScore),
                        label: "Avg Impact",
                        icon: "star.fill",
                        tint: AppColor.accent
                    )
                    StatMetricCell(
                        value: "\(viewModel.stats.totalImpactScore)",
                        label: "Total Impact",
                        icon: "chart.line.uptrend.xyaxis",
                        tint: Color(hex: "6C5CE7")
                    )
                    StatMetricCell(
                        value: "\(viewModel.stats.ritualDaysCompleted)",
                        label: "Rituals",
                        icon: "sparkles",
                        tint: Color(hex: "A29BFE")
                    )
                }

                ListMenuCell(
                    icon: "brain.head.profile",
                    iconTint: Color(hex: "A29BFE"),
                    title: "Mood Insights",
                    subtitle: "See how mood connects to your wins",
                    action: viewModel.goToMoodInsights
                )

                if viewModel.stats.totalAchievements > 0 {
                    HStack(spacing: 16) {
                        ProgressCircleView(
                            progress: Double(viewModel.stats.achievementsThisWeek) / Double(max(viewModel.stats.totalAchievements, 1)),
                            color: AppColor.accent,
                            label: "\(viewModel.stats.achievementsThisWeek)"
                        )
                        .frame(width: 88, height: 88)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Weekly Progress")
                                .font(.headline.weight(.semibold))
                                .foregroundColor(AppColor.textPrimary)
                            Text("\(viewModel.stats.achievementsThisWeek) wins this week")
                                .font(.caption)
                                .foregroundColor(AppColor.textSecondary)
                            Text("\(viewModel.stats.achievementsThisMonth) this month")
                                .font(.caption)
                                .foregroundColor(AppColor.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .appFloatingCard(tint: AppColor.accent)
                }

                if !viewModel.categoryData.isEmpty {
                    VStack(spacing: 12) {
                        AppSectionHeader(title: "By Category")
                        ForEach(viewModel.categoryData, id: \.0) { category, count in
                            CategoryStatsRow(category: category, count: count, total: viewModel.stats.totalAchievements)
                        }
                    }
                } else {
                    EmptyStateView(
                        icon: "📊",
                        title: "No Statistics Yet",
                        message: "Add wins to see your progress",
                        buttonTitle: "",
                        action: {}
                    )
                }
            }
        }
        .appPushedScreen(onBack: viewModel.goBack)
        .onAppear { viewModel.loadData() }
    }
}

struct CategoryStatsRow: View {
    let category: Category
    let count: Int
    let total: Int

    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }

    var body: some View {
        HStack(spacing: 14) {
            CategoryIconBadge(category: category, size: 40)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(category.rawValue)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(AppColor.textPrimary)
                    Spacer()
                    Text("\(count)")
                        .font(.headline.weight(.bold))
                        .foregroundColor(Color(hex: category.color))
                }

                AppProgressTrack(progress: percentage / 100, height: 8)
            }
        }
        .padding(14)
        .appListCard(tint: Color(hex: category.color), bordered: false)
    }
}
