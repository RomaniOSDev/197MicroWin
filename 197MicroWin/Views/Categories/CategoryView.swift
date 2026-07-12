import SwiftUI

struct CategoriesView: View {
    @StateObject private var viewModel: CategoriesViewModel

    init(viewModel: CategoriesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AppScrollScreen {
            VStack(spacing: AppLayout.sectionSpacing) {
                AppScreenTitleBar(emoji: "📂", title: "Categories")

                if let favorite = viewModel.favoriteCategory {
                    InsightMessageCell(
                        icon: "star.fill",
                        title: "Top category",
                        message: "\(favorite.icon) \(favorite.rawValue) is your most active area"
                    )
                }

                if viewModel.categoryStats.isEmpty {
                    EmptyStateView(
                        icon: "📂",
                        title: "No Categories Yet",
                        message: "Add wins to see category breakdown",
                        buttonTitle: "",
                        action: {}
                    )
                } else {
                    ForEach(viewModel.categoryStats, id: \.0) { category, count in
                        ListMenuCell(
                            icon: category.icon,
                            iconTint: Color(hex: category.color),
                            title: category.rawValue,
                            subtitle: "\(count) wins logged",
                            trailing: viewModel.favoriteCategory == category ? "⭐" : nil,
                            action: { viewModel.goToCategoryAchievements(category) }
                        )
                    }
                }
            }
        }
        .appPushedScreen(onBack: viewModel.goBack)
        .onAppear { viewModel.loadData() }
    }
}
