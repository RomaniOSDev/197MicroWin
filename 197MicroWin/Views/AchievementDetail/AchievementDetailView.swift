import SwiftUI

struct AchievementDetailView: View {
    @StateObject private var viewModel: AchievementDetailViewModel

    init(viewModel: AchievementDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            AppBackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        CategoryIconBadge(category: viewModel.achievement.category, size: 64)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(viewModel.achievement.category.rawValue)
                                .font(.headline.weight(.semibold))
                                .foregroundColor(AppColor.textPrimary)
                            Label(viewModel.formatDate(viewModel.achievement.date), systemImage: "calendar")
                                .font(.caption)
                                .foregroundColor(AppColor.textSecondary)
                        }
                        Spacer()
                        Button(action: viewModel.toggleFavorite) {
                            Image(systemName: viewModel.achievement.isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(viewModel.achievement.isFavorite ? Color(hex: "FF6B6B") : AppColor.textSecondary)
                                .frame(width: 44, height: 44)
                                .background(AppGradient.iconWell(tint: viewModel.achievement.isFavorite ? Color(hex: "FF6B6B") : AppColor.textSecondary))
                                .clipShape(Circle())
                        }
                    }

                    Text(viewModel.achievement.title)
                        .font(.title.weight(.bold))
                        .foregroundColor(AppColor.textPrimary)

                    HStack(spacing: 8) {
                        ImpactScoreBadge(score: viewModel.achievement.impactScore)
                        MetricBadge(icon: "circle.fill", text: viewModel.achievement.winSize.rawValue, tint: AppColor.accent)
                        MetricBadge(icon: "bolt.fill", text: viewModel.achievement.energy.rawValue, tint: Color(hex: "4CAF50"))
                        if let mood = viewModel.achievement.mood {
                            MetricBadge(icon: "face.smiling", text: mood.rawValue, tint: Color(hex: mood.color))
                        }
                    }

                    if let reflection = viewModel.achievement.reflectionNote {
                        detailBlock(title: "Reflection", icon: "lightbulb.fill", text: reflection)
                    }

                    if let description = viewModel.achievement.description {
                        detailBlock(title: "Note", icon: "note.text", text: description)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        AppSectionHeader(title: "Share Preview")
                        InsightShareCardView(
                            title: viewModel.achievement.title,
                            category: viewModel.achievement.category,
                            streak: viewModel.sharePreviewStreak,
                            insight: viewModel.weeklyInsight,
                            impactScore: viewModel.achievement.impactScore
                        )
                    }

                    VStack(spacing: 12) {
                        AppPrimaryButton(title: "Share Insight", icon: "square.and.arrow.up", action: viewModel.shareAchievement)
                        AppSecondaryButton(title: "Edit Win", icon: "pencil", action: viewModel.goToEdit)
                        AppDestructiveButton(title: "Delete Win", action: { viewModel.showDeleteAlert = true })
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, AppLayout.horizontalPadding)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .clearScrollBackground()
        }
        .appPushedScreen(onBack: viewModel.goBack)
        .alert("Delete this win?", isPresented: $viewModel.showDeleteAlert) {
            Button("Delete", role: .destructive, action: viewModel.deleteAchievement)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone")
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            ShareSheet(items: viewModel.shareItems)
        }
    }

    private func detailBlock(title: String, icon: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(AppColor.textPrimary)
            Text(text)
                .font(.body)
                .foregroundColor(AppColor.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .appListCard(tint: AppColor.accent, bordered: false)
        }
    }
}
