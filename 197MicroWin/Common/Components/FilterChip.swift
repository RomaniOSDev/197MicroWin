import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(chipBackground)
                .overlay(
                    Capsule()
                        .stroke(isSelected ? AppColor.accent.opacity(0.5) : Color.white.opacity(0.08), lineWidth: 1)
                )
                .foregroundColor(AppColor.textPrimary)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var chipBackground: some View {
        if isSelected {
            Capsule().fill(AppGradient.primaryButton(enabled: true))
        } else {
            Capsule().fill(AppGradient.cardSurface(tint: AppColor.accent))
        }
    }
}
