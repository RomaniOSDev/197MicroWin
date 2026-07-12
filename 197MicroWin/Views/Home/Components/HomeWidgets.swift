import SwiftUI

// MARK: - Hero Ritual Widget

struct HomeRitualHeroWidget: View {
    let isCompleted: Bool
    let streak: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                Image(HomeAsset.heroRitual)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 168)
                    .clipped()

                LinearGradient(
                    colors: [.clear, Color(hex: "0F1328").opacity(0.55), Color(hex: "0F1328").opacity(0.92)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 6) {
                        Label(isCompleted ? "Done today" : "Daily Ritual", systemImage: isCompleted ? "checkmark.seal.fill" : "sparkles")
                            .font(.caption.weight(.bold))
                            .foregroundColor(Color(hex: "FFD93D"))

                        Text(isCompleted ? "Ritual Complete" : "Start Daily Ritual")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)

                        Text(isCompleted ? "Come back tomorrow for day \(streak + 1)" : "2-minute guided win practice")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.82))
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.15))
                            .frame(width: 44, height: 44)
                        Image(systemName: "arrow.right")
                            .font(.body.weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(16)
            }
            .clipShape(RoundedRectangle(cornerRadius: AppLayout.cardRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppLayout.cardRadius, style: .continuous)
                    .stroke(isCompleted ? Color(hex: "4CAF50").opacity(0.5) : AppColor.accent.opacity(0.45), lineWidth: 1)
            )
            .modifier(AppShadowModifier(elevation: .hero))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Stats Row Widget

struct HomeStatsWidget: View {
    let wins: Int
    let streak: Int
    let impact: String
    let weekWins: Int
    var onWeekTap: (() -> Void)?

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                HomeMiniStatWidget(value: "\(wins)", label: "Wins", icon: "trophy.fill", tint: AppColor.accent)
                HomeMiniStatWidget(value: "\(streak)", label: "Streak", icon: "flame.fill", tint: Color(hex: "4CAF50"))
                HomeMiniStatWidget(value: impact, label: "Impact", icon: "star.fill", tint: Color(hex: "FFD93D"))
            }

            HomeProgressWidget(
                imageName: HomeAsset.widgetProgress,
                title: "This Week",
                value: "\(weekWins)",
                subtitle: "wins logged",
                progress: min(1, Double(weekWins) / 7.0),
                action: onWeekTap
            )
        }
    }
}

struct HomeMiniStatWidget: View {
    let value: String
    let label: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundColor(tint)
                .frame(width: 28, height: 28)
                .background(AppGradient.iconWell(tint: tint))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundColor(AppColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(label)
                .font(.caption2.weight(.medium))
                .foregroundColor(AppColor.textSecondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard(tint: tint, bordered: false, elevation: .raised)
    }
}

// MARK: - Image Progress Widget

struct HomeProgressWidget: View {
    let imageName: String
    let title: String
    let value: String
    let subtitle: String
    let progress: Double
    var action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: 0) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 96, height: 96)
                    .clipped()

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppColor.textSecondary)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(value)
                            .font(.title.weight(.bold))
                            .foregroundColor(AppColor.textPrimary)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(AppColor.textSecondary)
                    }

                    AppProgressTrack(progress: progress, height: 6)
                }
                .padding(14)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .appFloatingCard(tint: AppColor.accent)
        }
        .buttonStyle(.plain)
        .disabled(action == nil)
    }
}

// MARK: - Streak Widget with Image

struct HomeStreakWidget: View {
    let streak: Int
    let ritualDays: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                ZStack {
                    Image(HomeAsset.widgetStreak)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 110)
                        .clipped()

                    VStack {
                        Spacer()
                        Text("\(streak)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 4)
                            .padding(.bottom, 12)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Day Streak")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(AppColor.textPrimary)

                    Text("\(ritualDays) rituals completed")
                        .font(.caption)
                        .foregroundColor(AppColor.textSecondary)

                    Label("View calendar", systemImage: "calendar")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppColor.accent)
                }
                .padding(14)

                Spacer(minLength: 0)
            }
            .frame(height: 110)
            .appFloatingCard(tint: Color(hex: "4CAF50"))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Motivation Widget with Image

struct HomeMotivationWidget: View {
    let message: String
    let editAction: () -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(HomeAsset.widgetMotivation)
                .resizable()
                .scaledToFill()
                .frame(height: 130)
                .clipped()

            LinearGradient(
                colors: [.clear, Color(hex: "0F1328").opacity(0.7), Color(hex: "0F1328").opacity(0.95)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label("For you today", systemImage: "quote.bubble.fill")
                        .font(.caption.weight(.bold))
                        .foregroundColor(AppColor.accent)
                    Spacer()
                    Button("Edit", action: editAction)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white.opacity(0.9))
                }

                Text(message)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .padding(14)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppLayout.cardRadius, style: .continuous)
                .stroke(AppColor.accent.opacity(0.35), lineWidth: 1)
        )
        .modifier(AppShadowModifier(elevation: .floating))
    }
}

// MARK: - Reflection Banner Widget

struct HomeReflectionWidget: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppGradient.iconWell(tint: Color(hex: "FFD93D")))
                        .frame(width: 52, height: 52)
                    Image(systemName: "text.book.closed.fill")
                        .font(.title3)
                        .foregroundColor(Color(hex: "FFD93D"))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Weekly Reflection")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(AppColor.textPrimary)
                    Text("Review your week & set an intention")
                        .font(.caption)
                        .foregroundColor(AppColor.textSecondary)
                }

                Spacer()
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(hex: "FFD93D"))
            }
            .padding(14)
            .appFloatingCard(tint: Color(hex: "FFD93D"))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Focus Widget

struct HomeFocusWidget: View {
    let categories: [Category]
    let progress: [Category: Int]
    let neglected: Category?
    let editAction: () -> Void
    let categoryAction: (Category) -> Void

    var body: some View {
        VStack(spacing: 10) {
            AppSectionHeader(title: "Focus Areas", actionTitle: "Edit", action: editAction)

            if categories.isEmpty {
                Button(action: editAction) {
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(AppColor.accent)
                        Text("Set your monthly focus areas")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(AppColor.textPrimary)
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColor.accent)
                    }
                    .padding(14)
                    .appFloatingCard(tint: AppColor.accent)
                }
                .buttonStyle(.plain)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            HomeFocusChip(
                                category: category,
                                count: progress[category] ?? 0,
                                action: { categoryAction(category) }
                            )
                        }
                    }
                }

                if let neglected {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(Color(hex: "FFD93D"))
                        Text("\(neglected.rawValue) needs attention")
                            .font(.caption.weight(.medium))
                            .foregroundColor(AppColor.textSecondary)
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
    }
}

struct HomeFocusChip: View {
    let category: Category
    let count: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                CategoryIconBadge(category: category, size: 40)
                Text(category.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(AppColor.textPrimary)
                Text("\(count) wins")
                    .font(.caption2)
                    .foregroundColor(AppColor.textSecondary)
            }
            .padding(12)
            .frame(width: 120, alignment: .leading)
            .appListCard(tint: Color(hex: category.color), bordered: true)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quick Actions Widget

struct HomeQuickActionsWidget: View {
    let onAdd: () -> Void
    let onAllWins: () -> Void
    let onCalendar: () -> Void
    let onStats: () -> Void
    let onMood: () -> Void
    let onTemplates: () -> Void
    let onBadges: () -> Void
    let onFocus: () -> Void
    let onPhrases: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            AppSectionHeader(title: "Quick Actions")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ActionTileCell(icon: "plus.circle.fill", title: "Add", tint: AppColor.accent, action: onAdd)
                ActionTileCell(icon: "list.bullet", title: "All Wins", tint: AppColor.textSecondary, action: onAllWins)
                ActionTileCell(icon: "calendar", title: "Calendar", tint: Color(hex: "74B9FF"), action: onCalendar)
                ActionTileCell(icon: "chart.bar.fill", title: "Stats", tint: Color(hex: "4CAF50"), action: onStats)
                ActionTileCell(icon: "brain.head.profile", title: "Mood", tint: Color(hex: "A29BFE"), action: onMood)
                ActionTileCell(icon: "doc.text.fill", title: "Templates", tint: Color(hex: "E17055"), action: onTemplates)
                ActionTileCell(icon: "medal.fill", title: "Badges", tint: Color(hex: "FFD93D"), action: onBadges)
                ActionTileCell(icon: "target", title: "Focus", tint: Color(hex: "FF6B6B"), action: onFocus)
                ActionTileCell(icon: "text.quote", title: "Phrases", tint: AppColor.accent, action: onPhrases)
            }
        }
    }
}

// MARK: - Milestone Widget

struct HomeMilestoneWidget: View {
    let milestones: [Milestone]
    let action: () -> Void

    var body: some View {
        if let latest = milestones.first {
            Button(action: action) {
                HStack(spacing: 12) {
                    Text(latest.type.icon)
                        .font(.largeTitle)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("New Badge Unlocked!")
                            .font(.caption.weight(.bold))
                            .foregroundColor(Color(hex: "FFD93D"))
                        Text(latest.type.title)
                            .font(.headline.weight(.semibold))
                            .foregroundColor(AppColor.textPrimary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColor.textSecondary)
                }
                .padding(14)
                .appFloatingCard(tint: Color(hex: "FFD93D"))
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Recent Wins Widget

struct HomeRecentWinsWidget: View {
    let achievements: [Achievement]
    let seeAllAction: () -> Void
    let addAction: () -> Void
    let detailAction: (Achievement) -> Void

    var body: some View {
        VStack(spacing: 12) {
            AppSectionHeader(title: "Recent Wins", actionTitle: "See all", action: seeAllAction)

            if achievements.isEmpty {
                EmptyStateView(
                    icon: "🏆",
                    title: "No wins yet",
                    message: "Start your daily ritual or add a win",
                    buttonTitle: "Add Win",
                    action: addAction
                )
            } else {
                ForEach(achievements) { achievement in
                    AchievementCardView(achievement: achievement) {
                        detailAction(achievement)
                    }
                }
            }
        }
    }
}

// MARK: - Header

struct HomeGreetingHeader: View {
    let greeting: String
    let subtitle: String
    let settingsAction: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.title2.weight(.bold))
                    .foregroundColor(AppColor.textPrimary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(AppColor.textSecondary)
            }

            Spacer()

            Button(action: settingsAction) {
                Image(systemName: "gearshape.fill")
                    .font(.body.weight(.semibold))
                    .foregroundColor(AppColor.textSecondary)
                    .frame(width: 42, height: 42)
                    .background(AppGradient.cardSurface(tint: AppColor.accent))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(AppColor.accent.opacity(0.25), lineWidth: 1))
                    .modifier(AppShadowModifier(elevation: .raised))
            }
        }
    }
}
