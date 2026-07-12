import SwiftUI

struct HomeView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel: HomeViewModel
    @State private var didAutoShowReflection = false

    init(viewModel: HomeViewModel, coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                AppBackgroundView()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppLayout.sectionSpacing) {
                        HomeGreetingHeader(
                            greeting: viewModel.greeting,
                            subtitle: viewModel.greetingSubtitle,
                            settingsAction: viewModel.goToSettings
                        )

                        HomeRitualHeroWidget(
                            isCompleted: viewModel.ritualCompletedToday,
                            streak: viewModel.streakDays,
                            action: viewModel.goToDailyRitual
                        )

                        if viewModel.showWeeklyReflectionPrompt {
                            HomeReflectionWidget(action: viewModel.goToWeeklyReflection)
                        }

                        if let milestone = viewModel.latestMilestone {
                            HomeMilestoneWidget(milestones: [milestone], action: viewModel.goToMilestones)
                        }

                        HomeStatsWidget(
                            wins: viewModel.totalAchievements,
                            streak: viewModel.streakDays,
                            impact: viewModel.averageImpact,
                            weekWins: viewModel.weekWins,
                            onWeekTap: viewModel.goToStatistics
                        )

                        HomeStreakWidget(
                            streak: viewModel.streakDays,
                            ritualDays: viewModel.ritualDays,
                            action: viewModel.goToCalendar
                        )

                        if let message = viewModel.personalMessage {
                            HomeMotivationWidget(
                                message: message,
                                editAction: viewModel.goToPersonalMotivation
                            )
                        }

                        HomeFocusWidget(
                            categories: viewModel.focusAreas,
                            progress: viewModel.focusProgress,
                            neglected: viewModel.neglectedAreas.first,
                            editAction: viewModel.goToFocusAreas,
                            categoryAction: { viewModel.goToAchievementList(category: $0) }
                        )

                        HomeQuickActionsWidget(
                            onAdd: viewModel.goToAchievementForm,
                            onAllWins: { viewModel.goToAchievementList() },
                            onCalendar: viewModel.goToCalendar,
                            onStats: viewModel.goToStatistics,
                            onMood: viewModel.goToMoodInsights,
                            onTemplates: viewModel.goToTemplates,
                            onBadges: viewModel.goToMilestones,
                            onFocus: viewModel.goToFocusAreas,
                            onPhrases: viewModel.goToPersonalMotivation
                        )

                        HomeRecentWinsWidget(
                            achievements: viewModel.recentAchievements,
                            seeAllAction: { viewModel.goToAchievementList() },
                            addAction: viewModel.goToAchievementForm,
                            detailAction: viewModel.goToAchievementDetail
                        )
                    }
                    .padding(.horizontal, AppLayout.horizontalPadding)
                    .padding(.top, 12)
                    .padding(.bottom, 32)
                }
                .clearScrollBackground()
            }
            .navigationDestination(for: AppRoute.self) { route in
                coordinator.destination(for: route)
            }
            .onAppear {
                viewModel.loadData()
                if viewModel.showWeeklyReflectionPrompt && !didAutoShowReflection {
                    didAutoShowReflection = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.goToWeeklyReflection()
                    }
                }
            }
            .onChange(of: coordinator.path.count) { _, _ in
                if coordinator.path.isEmpty { viewModel.loadData() }
            }
        }
        .background(Color.clear)
    }
}
