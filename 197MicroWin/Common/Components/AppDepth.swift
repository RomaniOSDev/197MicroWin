import SwiftUI

// MARK: - Elevation (single shadow per surface — scroll-friendly)

enum AppElevation {
    case flat
    case raised
    case floating
    case hero

    var shadowOpacity: Double {
        switch self {
        case .flat: return 0
        case .raised: return 0.22
        case .floating: return 0.28
        case .hero: return 0.35
        }
    }

    var shadowRadius: CGFloat {
        switch self {
        case .flat: return 0
        case .raised: return 6
        case .floating: return 10
        case .hero: return 14
        }
    }

    var shadowY: CGFloat {
        switch self {
        case .flat: return 0
        case .raised: return 3
        case .floating: return 5
        case .hero: return 8
        }
    }
}

// MARK: - Static gradients (no animation, GPU-friendly)

enum AppGradient {
    static let screenBackground: [Color] = [
        Color(hex: "0B1024"),
        Color(hex: "0F1328"),
        Color(hex: "121A38")
    ]

    static func cardSurface(tint: Color) -> LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "24304D"),
                Color(hex: "1A2339"),
                Color(hex: "141C30")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func cardSheen(tint: Color) -> LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.14),
                tint.opacity(0.12),
                Color.clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func primaryButton(enabled: Bool) -> LinearGradient {
        LinearGradient(
            colors: enabled
                ? [Color(hex: "0390F0"), AppColor.accent, Color(hex: "0256A8")]
                : [Color.gray.opacity(0.45), Color.gray.opacity(0.35)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var accentBar: LinearGradient {
        LinearGradient(
            colors: [AppColor.accent, Color(hex: "6C5CE7")],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static var progressFill: LinearGradient {
        LinearGradient(
            colors: [AppColor.accent, Color(hex: "6C5CE7")],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static func iconWell(tint: Color) -> LinearGradient {
        LinearGradient(
            colors: [tint.opacity(0.28), tint.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Card modifier

struct AppCardModifier: ViewModifier {
    var tint: Color = AppColor.accent
    var bordered: Bool = true
    var elevation: AppElevation = .raised

    func body(content: Content) -> some View {
        content
            .background(cardBackground)
            .modifier(AppShadowModifier(elevation: elevation))
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: AppLayout.cardRadius, style: .continuous)
            .fill(AppGradient.cardSurface(tint: tint))
            .overlay(
                RoundedRectangle(cornerRadius: AppLayout.cardRadius, style: .continuous)
                    .fill(AppGradient.cardSheen(tint: tint))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppLayout.cardRadius, style: .continuous)
                    .stroke(
                        bordered ? tint.opacity(0.22) : Color.white.opacity(0.06),
                        lineWidth: 1
                    )
            )
    }
}

struct AppShadowModifier: ViewModifier {
    let elevation: AppElevation

    func body(content: Content) -> some View {
        if elevation == .flat {
            content
        } else {
            content
                .compositingGroup()
                .shadow(
                    color: Color.black.opacity(elevation.shadowOpacity),
                    radius: elevation.shadowRadius,
                    x: 0,
                    y: elevation.shadowY
                )
        }
    }
}

extension View {
    func appCard(
        tint: Color = AppColor.accent,
        bordered: Bool = true,
        elevation: AppElevation = .raised
    ) -> some View {
        modifier(AppCardModifier(tint: tint, bordered: bordered, elevation: elevation))
    }

    /// List rows: gradient depth without shadow (scroll-optimized).
    func appListCard(tint: Color = AppColor.accent, bordered: Bool = true) -> some View {
        appCard(tint: tint, bordered: bordered, elevation: .flat)
    }

    func appFloatingCard(tint: Color = AppColor.accent) -> some View {
        appCard(tint: tint, bordered: true, elevation: .floating)
    }

    func appHeroSurface(tint: Color = AppColor.accent) -> some View {
        appCard(tint: tint, bordered: true, elevation: .hero)
    }
}
