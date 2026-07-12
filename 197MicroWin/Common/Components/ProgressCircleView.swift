import SwiftUI

struct ProgressCircleView: View {
    let progress: Double
    let lineWidth: CGFloat
    let color: Color
    let label: String

    init(progress: Double, lineWidth: CGFloat = 8, color: Color = AppColor.accent, label: String = "") {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = lineWidth
        self.color = color
        self.label = label
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColor.card, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [color, color.opacity(0.6), color],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            if !label.isEmpty {
                Text(label)
                    .font(.headline.weight(.bold))
                    .foregroundColor(AppColor.textPrimary)
            }
        }
    }
}
