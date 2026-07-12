import SwiftUI

struct InsightShareCardView: View {
    let title: String
    let category: Category
    let streak: Int
    let insight: String
    let impactScore: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                CategoryIconBadge(category: category, size: 44)
                Spacer()
                ImpactScoreBadge(score: impactScore)
            }

            Text(title)
                .font(.title3.weight(.bold))
                .foregroundColor(AppColor.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                CategoryBadgeView(category: category)
                Spacer()
                Label("\(streak)d streak", systemImage: "flame.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Color(hex: "FFD93D"))
            }

            Divider().overlay(AppColor.textSecondary.opacity(0.25))

            Text(insight)
                .font(.subheadline)
                .foregroundColor(AppColor.textSecondary)
                .italic()
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .appHeroSurface(tint: Color(hex: category.color))
    }
}

struct InsightShareCardRenderer {
    @MainActor
    static func renderImage(
        title: String,
        category: Category,
        streak: Int,
        insight: String,
        impactScore: Int
    ) -> UIImage? {
        let view = InsightShareCardView(
            title: title,
            category: category,
            streak: streak,
            insight: insight,
            impactScore: impactScore
        )
        .frame(width: 340)
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}
