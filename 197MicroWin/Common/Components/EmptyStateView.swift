import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(AppGradient.iconWell(tint: AppColor.accent))
                    .frame(width: 88, height: 88)
                Text(icon)
                    .font(.system(size: 40))
            }
            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))

            VStack(spacing: 8) {
                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(AppColor.textPrimary)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(AppColor.textSecondary)
                    .multilineTextAlignment(.center)
            }

            if !buttonTitle.isEmpty {
                AppPrimaryButton(title: buttonTitle, icon: "plus.circle.fill", action: action)
                    .frame(maxWidth: 220)
            }
        }
        .padding(24)
        .appFloatingCard(tint: AppColor.accent)
        .padding(.horizontal, AppLayout.horizontalPadding)
    }
}
