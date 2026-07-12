import SwiftUI

struct FocusAreasView: View {
    @StateObject private var viewModel: FocusAreasViewModel

    init(viewModel: FocusAreasViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AppScrollScreen {
            VStack(spacing: AppLayout.sectionSpacing) {
                AppScreenTitleBar(emoji: "🎯", title: "Focus Areas")

                InsightMessageCell(
                    icon: "target",
                    title: "Monthly focus",
                    message: "Pick up to 3 areas to prioritize this month"
                )

                VStack(spacing: 10) {
                    ForEach(Category.allCases, id: \.self) { category in
                        let isSelected = viewModel.selectedCategories.contains(category)
                        Button {
                            viewModel.toggle(category)
                        } label: {
                            HStack(spacing: 14) {
                                CategoryIconBadge(category: category, size: 44)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(category.rawValue)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(AppColor.textPrimary)
                                    if isSelected, let count = viewModel.progressMap[category] {
                                        Text("\(count) wins this month")
                                            .font(.caption)
                                            .foregroundColor(AppColor.textSecondary)
                                    }
                                }
                                Spacer()
                                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)
                                    .foregroundColor(isSelected ? AppColor.accent : AppColor.textSecondary)
                            }
                            .padding(14)
                            .appListCard(
                                tint: isSelected ? Color(hex: category.color) : AppColor.accent,
                                bordered: isSelected
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                if !viewModel.neglected.isEmpty {
                    HeroBannerCell(
                        title: "Some areas need attention",
                        subtitle: viewModel.neglected.map(\.rawValue).joined(separator: ", "),
                        style: .warning,
                        action: {}
                    )
                }

                AppPrimaryButton(title: "Save Focus Areas", icon: "checkmark.circle.fill", action: viewModel.save)
            }
        }
        .appPushedScreen(onBack: viewModel.goBack)
    }
}
