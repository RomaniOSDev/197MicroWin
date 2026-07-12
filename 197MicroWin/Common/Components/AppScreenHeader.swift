import SwiftUI

struct AppScreenHeader: View {
    let emoji: String
    let title: String
    let subtitle: String?
    var trailingIcon: String = "gearshape.fill"
    var trailingAction: (() -> Void)?

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppGradient.iconWell(tint: AppColor.accent))
                    .frame(width: 52, height: 52)
                Text(emoji)
                    .font(.system(size: 26))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2.weight(.bold))
                    .foregroundColor(AppColor.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(AppColor.textSecondary)
                }
            }

            Spacer(minLength: 0)

            if let trailingAction {
                Button(action: trailingAction) {
                    Image(systemName: trailingIcon)
                        .font(.body.weight(.semibold))
                        .foregroundColor(AppColor.textSecondary)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(AppGradient.cardSurface(tint: AppColor.accent))
                        )
                        .overlay(Circle().stroke(AppColor.accent.opacity(0.25), lineWidth: 1))
                }
            }
        }
    }
}

struct AppSectionHeader: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(AppTypography.sectionTitle)
                    .foregroundColor(AppColor.textPrimary)
                Spacer()
                if let actionTitle, let action {
                    Button(actionTitle, action: action)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppColor.accent)
                }
            }
            Capsule()
                .fill(AppGradient.accentBar)
                .frame(height: 2)
                .opacity(0.55)
        }
    }
}

struct AppBackToolbar: ToolbarContent {
    let title: String?
    let action: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: action) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.body.weight(.semibold))
                    if let title {
                        Text(title)
                    }
                }
                .foregroundColor(AppColor.accent)
            }
        }
    }
}

struct AppScreenTitleBar: View {
    let emoji: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Text(emoji)
                    .font(.title2)
                Text(title)
                    .font(AppTypography.screenTitle)
                    .foregroundColor(AppColor.textPrimary)
                Spacer()
            }
            Capsule()
                .fill(AppGradient.accentBar)
                .frame(height: 3)
                .opacity(0.7)
        }
        .padding(.top, 4)
    }
}
