import SwiftUI

struct WeeklyReflectionScreen: View {
    @StateObject private var viewModel: WeeklyReflectionViewModel

    init(viewModel: WeeklyReflectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AppScrollScreen {
            VStack(spacing: AppLayout.sectionSpacing) {
                AppScreenTitleBar(emoji: "📝", title: "Weekly Reflection")

                if !viewModel.topWins.isEmpty {
                    VStack(spacing: 10) {
                        AppSectionHeader(title: "Top 3 Wins")
                        ForEach(Array(viewModel.topWins.enumerated()), id: \.element.id) { index, win in
                            HStack(spacing: 14) {
                                Text("#\(index + 1)")
                                    .font(.caption.weight(.bold))
                                    .foregroundColor(AppColor.accent)
                                    .frame(width: 28, height: 28)
                                    .background(AppColor.accent.opacity(0.15))
                                    .clipShape(Circle())
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(win.title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(AppColor.textPrimary)
                                    Text(win.category.rawValue)
                                        .font(.caption)
                                        .foregroundColor(AppColor.textSecondary)
                                }
                                Spacer()
                                ImpactScoreBadge(score: win.impactScore)
                            }
                            .padding(14)
                            .appListCard(tint: Color(hex: win.category.color), bordered: false)
                        }
                    }
                }

                if let category = viewModel.mostActiveCategory {
                    InsightMessageCell(
                        icon: "chart.bar.fill",
                        title: "Most active category",
                        message: "\(category.icon) \(category.rawValue) led your week"
                    )
                }

                AppTextEditorCell(label: "What pattern do you notice?", text: $viewModel.patternNote, minHeight: 90)
                AppTextEditorCell(label: "One intention for next week", text: $viewModel.intention, minHeight: 90)

                AppPrimaryButton(
                    title: "Save Reflection",
                    icon: "checkmark.circle.fill",
                    enabled: viewModel.isValid,
                    action: viewModel.save
                )
            }
        }
        .appPushedScreen(onBack: viewModel.goBack)
    }
}
