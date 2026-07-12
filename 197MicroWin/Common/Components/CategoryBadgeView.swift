import SwiftUI

struct CategoryBadgeView: View {
    let category: Category

    var body: some View {
        HStack(spacing: 4) {
            Text(category.icon)
            Text(category.rawValue)
                .font(.caption2.weight(.semibold))
        }
        .foregroundColor(Color(hex: category.color))
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(AppGradient.iconWell(tint: Color(hex: category.color)))
        .clipShape(Capsule())
    }
}
