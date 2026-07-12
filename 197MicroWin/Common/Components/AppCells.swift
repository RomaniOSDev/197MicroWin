import SwiftUI

struct StatMetricCell: View {
    let value: String
    let label: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.caption.weight(.bold))
                    .foregroundColor(tint)
                    .frame(width: 28, height: 28)
                    .background(tint.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                Spacer()
            }

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundColor(AppColor.textPrimary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(label)
                .font(.caption)
                .foregroundColor(AppColor.textSecondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard(tint: tint, bordered: false, elevation: .raised)
    }
}

struct HeroBannerCell: View {
    enum Style {
        case ritual, reflection, completed, warning

        var gradient: [Color] {
            switch self {
            case .ritual: return [AppColor.accent.opacity(0.35), Color(hex: "6C5CE7").opacity(0.25)]
            case .reflection: return [Color(hex: "FFD93D").opacity(0.25), AppColor.accent.opacity(0.2)]
            case .completed: return [Color(hex: "4CAF50").opacity(0.25), AppColor.accent.opacity(0.15)]
            case .warning: return [Color(hex: "FF6B6B").opacity(0.22), Color(hex: "FFD93D").opacity(0.15)]
            }
        }

        var icon: String {
            switch self {
            case .ritual: return "sparkles"
            case .reflection: return "text.book.closed.fill"
            case .completed: return "checkmark.seal.fill"
            case .warning: return "exclamationmark.triangle.fill"
            }
        }
    }

    let title: String
    let subtitle: String
    let style: Style
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: style.icon)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(AppColor.textPrimary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(AppColor.textPrimary)
                        .multilineTextAlignment(.leading)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(AppColor.textSecondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 0)

                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(AppColor.textPrimary.opacity(0.85))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: AppLayout.cardRadius, style: .continuous)
                    .fill(LinearGradient(colors: style.gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppLayout.cardRadius, style: .continuous)
                            .fill(AppGradient.cardSheen(tint: AppColor.accent))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppLayout.cardRadius, style: .continuous)
                            .stroke(Color.white.opacity(0.14), lineWidth: 1)
                    )
            )
            .modifier(AppShadowModifier(elevation: .floating))
        }
        .buttonStyle(.plain)
    }
}

struct ActionTileCell: View {
    let icon: String
    let title: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppGradient.iconWell(tint: tint))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                        .foregroundColor(tint)
                }

                Text(title)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(AppColor.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .appCard(tint: tint, bordered: false, elevation: .raised)
        }
        .buttonStyle(.plain)
    }
}

struct ListMenuCell: View {
    let icon: String
    let iconTint: Color
    let title: String
    var subtitle: String?
    var trailing: String?
    var showChevron: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(AppGradient.iconWell(tint: iconTint))
                        .frame(width: 44, height: 44)
                    if icon.contains(".") {
                        Image(systemName: icon)
                            .font(.body.weight(.semibold))
                            .foregroundColor(iconTint)
                    } else {
                        Text(icon).font(.title3)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(AppTypography.cellTitle)
                        .foregroundColor(AppColor.textPrimary)
                    if let subtitle {
                        Text(subtitle)
                            .font(AppTypography.cellSubtitle)
                            .foregroundColor(AppColor.textSecondary)
                    }
                }

                Spacer(minLength: 0)

                if let trailing {
                    Text(trailing)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(iconTint)
                }

                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundColor(AppColor.textSecondary.opacity(0.7))
                }
            }
            .padding(14)
            .appListCard(tint: iconTint)
        }
        .buttonStyle(.plain)
    }
}

struct InsightMessageCell: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(AppColor.textSecondary)
                Spacer()
                if let actionTitle, let action {
                    Button(actionTitle, action: action)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppColor.accent)
                }
            }

            Text(message)
                .font(.headline.weight(.medium))
                .foregroundColor(AppColor.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .appFloatingCard(tint: AppColor.accent)
    }
}

struct MetricBadge: View {
    let icon: String
    let text: String
    let tint: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2.weight(.bold))
            Text(text)
                .font(.caption2.weight(.semibold))
        }
        .foregroundColor(tint)
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(AppGradient.iconWell(tint: tint))
        )
        .overlay(Capsule().stroke(tint.opacity(0.25), lineWidth: 0.5))
    }
}

struct CategoryIconBadge: View {
    let category: Category
    var size: CGFloat = 48

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                .fill(AppGradient.iconWell(tint: Color(hex: category.color)))
                .frame(width: size, height: size)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                        .stroke(Color(hex: category.color).opacity(0.35), lineWidth: 1)
                )
            Text(category.icon)
                .font(.system(size: size * 0.46))
        }
    }
}

struct ImpactScoreBadge: View {
    let score: Int

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill")
                .font(.caption2)
            Text("\(score)")
                .font(.caption.weight(.bold))
        }
        .foregroundColor(Color(hex: "FFD93D"))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule().fill(AppGradient.iconWell(tint: Color(hex: "FFD93D")))
        )
        .overlay(Capsule().stroke(Color(hex: "FFD93D").opacity(0.35), lineWidth: 0.5))
    }
}
