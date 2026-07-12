import SwiftUI

struct MilestonesView: View {
    @StateObject private var viewModel: MilestonesViewModel

    init(viewModel: MilestonesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AppScrollScreen {
            VStack(spacing: AppLayout.sectionSpacing) {
                AppScreenTitleBar(emoji: "🎖️", title: "Milestones")

                VStack(spacing: 12) {
                    ForEach(viewModel.allTypes, id: \.self) { type in
                        MilestoneRow(
                            type: type,
                            isUnlocked: viewModel.isUnlocked(type),
                            progress: viewModel.progress(for: type)
                        )
                    }
                }
            }
        }
        .appPushedScreen(onBack: viewModel.goBack)
        .onAppear { viewModel.load() }
    }
}

struct MilestoneRow: View {
    let type: MilestoneType
    let isUnlocked: Bool
    let progress: Double

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        isUnlocked
                            ? AnyShapeStyle(AppGradient.iconWell(tint: Color(hex: "FFD93D")))
                            : AnyShapeStyle(AppGradient.cardSurface(tint: AppColor.accent))
                    )
                    .frame(width: 52, height: 52)
                Text(type.icon)
                    .font(.title2)
                    .opacity(isUnlocked ? 1 : 0.45)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(type.title)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(isUnlocked ? AppColor.textPrimary : AppColor.textSecondary)
                Text(type.description)
                    .font(.caption)
                    .foregroundColor(AppColor.textSecondary)

                if !isUnlocked {
                    AppProgressTrack(progress: progress, height: 6)
                }
            }

            Spacer(minLength: 0)

            if isUnlocked {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title2)
                    .foregroundColor(Color(hex: "FFD93D"))
            } else {
                Text("\(Int(progress * 100))%")
                    .font(.caption.weight(.bold))
                    .foregroundColor(AppColor.accent)
            }
        }
        .padding(14)
        .appListCard(tint: isUnlocked ? Color(hex: "FFD93D") : AppColor.accent, bordered: false)
    }
}
