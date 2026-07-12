import SwiftUI

struct RitualCompletionView: View {
    let streak: Int
    let onDone: () -> Void

    @State private var animate = false

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 28) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppColor.accent.opacity(0.35), .clear],
                                center: .center,
                                startRadius: 10,
                                endRadius: 90
                            )
                        )
                        .frame(width: 160, height: 160)
                        .scaleEffect(animate ? 1.05 : 0.9)

                    Text("✨")
                        .font(.system(size: 72))
                        .scaleEffect(animate ? 1.15 : 0.85)
                }

                VStack(spacing: 10) {
                    Text("Ritual Complete!")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(AppColor.textPrimary)
                    Text("Day \(max(streak, 1)) of awareness")
                        .font(.headline)
                        .foregroundColor(AppColor.textSecondary)
                }

                VStack(spacing: 8) {
                    AppProgressTrack(
                        progress: min(1, Double(streak) / 7),
                        height: 8
                    )
                    Text("Keep showing up — small wins compound")
                        .font(.subheadline)
                        .foregroundColor(AppColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(16)
                .appFloatingCard(tint: AppColor.accent)
                .padding(.horizontal, 40)

                Spacer()

                AppPrimaryButton(title: "Continue", icon: "arrow.right", action: onDone)
                    .padding(.horizontal, AppLayout.horizontalPadding)
                    .padding(.bottom, 32)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.65)) {
                animate = true
            }
        }
    }
}
