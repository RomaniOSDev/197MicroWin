import SwiftUI

enum AppLayout {
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 22
    static let cardRadius: CGFloat = 18
    static let chipRadius: CGFloat = 12
}

enum AppTypography {
    static let screenTitle = Font.title2.weight(.bold)
    static let sectionTitle = Font.headline.weight(.semibold)
    static let cellTitle = Font.subheadline.weight(.semibold)
    static let cellSubtitle = Font.caption
}

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: AppGradient.screenBackground,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [AppColor.accent.opacity(0.16), .clear],
                center: .topTrailing,
                startRadius: 20,
                endRadius: 300
            )

            RadialGradient(
                colors: [Color(hex: "6C5CE7").opacity(0.1), .clear],
                center: .bottomLeading,
                startRadius: 10,
                endRadius: 260
            )
        }
        .ignoresSafeArea()
    }
}
