import SwiftUI

struct MoodInsightsView: View {
    @StateObject private var viewModel: MoodInsightsViewModel

    init(viewModel: MoodInsightsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AppScrollScreen {
            VStack(spacing: AppLayout.sectionSpacing) {
                AppScreenTitleBar(emoji: "🧠", title: "Mood Insights")

                if viewModel.insights.isEmpty {
                    EmptyStateView(
                        icon: "🧠",
                        title: "Not Enough Data",
                        message: "Log mood with your wins to unlock insights",
                        buttonTitle: "",
                        action: {}
                    )
                } else {
                    ForEach(viewModel.insights) { insight in
                        InsightMessageCell(
                            icon: "lightbulb.fill",
                            title: "Insight",
                            message: "\(insight.icon) \(insight.message)"
                        )
                    }
                }

                if !viewModel.stats.winsByMood.isEmpty {
                    VStack(spacing: 10) {
                        AppSectionHeader(title: "Wins by Mood")
                        ForEach(viewModel.stats.winsByMood.sorted { $0.value > $1.value }, id: \.key) { mood, count in
                            ListMenuCell(
                                icon: mood.icon,
                                iconTint: Color(hex: mood.color),
                                title: mood.rawValue,
                                subtitle: "Logged wins",
                                trailing: "\(count)",
                                showChevron: false,
                                action: {}
                            )
                        }
                    }
                }
            }
        }
        .appPushedScreen(onBack: viewModel.goBack)
        .onAppear { viewModel.loadData() }
    }
}
