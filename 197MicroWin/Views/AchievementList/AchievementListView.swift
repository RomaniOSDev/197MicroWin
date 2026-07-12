import SwiftUI

struct AchievementListView: View {
    @StateObject private var viewModel: AchievementListViewModel

    init(viewModel: AchievementListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 14) {
                AppSearchBar(text: $viewModel.searchText, placeholder: "Search wins...")
                    .padding(.horizontal, AppLayout.horizontalPadding)
                    .padding(.top, 8)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(
                            title: "All",
                            isSelected: viewModel.selectedCategory == nil && !viewModel.showFavoritesOnly,
                            action: {
                                viewModel.selectedCategory = nil
                                viewModel.showFavoritesOnly = false
                            }
                        )
                        FilterChip(
                            title: "❤️ Favorites",
                            isSelected: viewModel.showFavoritesOnly,
                            action: {
                                viewModel.showFavoritesOnly.toggle()
                                if viewModel.showFavoritesOnly { viewModel.selectedCategory = nil }
                            }
                        )
                        ForEach(Category.allCases, id: \.self) { category in
                            FilterChip(
                                title: "\(category.icon) \(category.rawValue)",
                                isSelected: viewModel.selectedCategory == category,
                                action: {
                                    if viewModel.selectedCategory == category {
                                        viewModel.selectedCategory = nil
                                    } else {
                                        viewModel.selectedCategory = category
                                        viewModel.showFavoritesOnly = false
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, AppLayout.horizontalPadding)
                }

                if !viewModel.filteredAchievements.isEmpty {
                    Text("\(viewModel.filteredAchievements.count) wins")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppColor.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, AppLayout.horizontalPadding)
                }

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredAchievements) { achievement in
                            AchievementCardView(achievement: achievement) {
                                viewModel.goToAchievementDetail(achievement)
                            }
                            .contextMenu {
                                Button {
                                    viewModel.toggleFavorite(achievement)
                                } label: {
                                    Label(
                                        achievement.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                                        systemImage: achievement.isFavorite ? "heart.slash" : "heart"
                                    )
                                }
                                Button("Delete", role: .destructive) {
                                    viewModel.deleteAchievement(achievement)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppLayout.horizontalPadding)
                    .padding(.vertical, 8)
                }
                .clearScrollBackground()
                .overlay {
                    if viewModel.filteredAchievements.isEmpty {
                        EmptyStateView(
                            icon: "🏆",
                            title: "No Wins Yet",
                            message: viewModel.searchText.isEmpty
                                ? "Add your first win to get started"
                                : "Nothing found for your search",
                            buttonTitle: "Add Win",
                            action: viewModel.goToAchievementForm
                        )
                    }
                }
            }
        }
        .appPushedScreen(onBack: viewModel.goBack)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.goToAchievementForm) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(AppColor.accent)
                }
            }
        }
        .onAppear { viewModel.loadAchievements() }
    }
}
