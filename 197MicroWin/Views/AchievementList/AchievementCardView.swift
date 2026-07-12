import SwiftUI

struct AchievementCardView: View {
    let achievement: Achievement
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                CategoryIconBadge(category: achievement.category, size: 52)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        Text(achievement.title)
                            .font(.headline.weight(.semibold))
                            .foregroundColor(AppColor.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 8)
                        if achievement.isFavorite {
                            Image(systemName: "heart.fill")
                                .font(.caption)
                                .foregroundColor(Color(hex: "FF6B6B"))
                        }
                    }

                    HStack(spacing: 6) {
                        Text(achievement.category.rawValue)
                            .font(.caption.weight(.medium))
                            .foregroundColor(AppColor.textSecondary)
                        Text("•")
                            .foregroundColor(AppColor.textSecondary.opacity(0.5))
                        Text(formatDate(achievement.date))
                            .font(.caption)
                            .foregroundColor(AppColor.textSecondary)
                    }

                    HStack(spacing: 6) {
                        ImpactScoreBadge(score: achievement.impactScore)
                        MetricBadge(icon: "circle.fill", text: achievement.winSize.rawValue, tint: AppColor.accent)
                        if let mood = achievement.mood {
                            MetricBadge(icon: "face.smiling", text: mood.rawValue, tint: Color(hex: mood.color))
                        }
                        if achievement.fromRitual {
                            MetricBadge(icon: "sparkles", text: "Ritual", tint: Color(hex: "6C5CE7"))
                        }
                    }

                    if let description = achievement.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(AppColor.textSecondary)
                            .lineLimit(2)
                    }
                }

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(AppColor.textSecondary.opacity(0.5))
            }
            .padding(14)
            .appListCard(tint: Color(hex: achievement.category.color))
        }
        .buttonStyle(.plain)
    }

    private func formatDate(_ date: Date) -> String {
        DateFormatter.achievementDate.string(from: date)
    }
}
