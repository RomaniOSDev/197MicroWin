import SwiftUI

struct WinMetricsPickerView: View {
    @Binding var winSize: WinSize
    @Binding var energy: EnergyLevel
    @Binding var impactScore: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            metricSection(title: "Win Size", options: WinSize.allCases.map { ($0.icon + " " + $0.rawValue, $0) }, selection: $winSize)
            metricSection(title: "Energy", options: EnergyLevel.allCases.map { ($0.icon + " " + $0.rawValue, $0) }, selection: $energy)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Impact Score")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppColor.textSecondary)
                    Spacer()
                    ImpactScoreBadge(score: impactScore)
                }
                Slider(value: Binding(
                    get: { Double(impactScore) },
                    set: { impactScore = Int($0.rounded()) }
                ), in: 1...5, step: 1)
                .tint(AppColor.accent)
            }
        }
    }

    private func metricSection<T: Hashable>(title: String, options: [(String, T)], selection: Binding<T>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColor.textSecondary)
            HStack(spacing: 8) {
                ForEach(options, id: \.1) { label, value in
                    SelectChip(title: label, isSelected: selection.wrappedValue == value) {
                        selection.wrappedValue = value
                    }
                }
            }
        }
    }
}

struct MoodPickerView: View {
    @Binding var selectedMood: Mood?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How do you feel?")
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColor.textSecondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    Button {
                        selectedMood = mood
                    } label: {
                        VStack(spacing: 6) {
                            Text(mood.icon).font(.title3)
                            Text(mood.rawValue)
                                .font(.caption2.weight(.medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(
                                    selectedMood == mood
                                        ? AnyShapeStyle(AppGradient.iconWell(tint: Color(hex: mood.color)))
                                        : AnyShapeStyle(AppGradient.cardSurface(tint: AppColor.accent))
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(selectedMood == mood ? Color(hex: mood.color) : Color.clear, lineWidth: 1.5)
                        )
                        .foregroundColor(AppColor.textPrimary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct SelectChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 10)
                .padding(.vertical, 9)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            isSelected
                                ? AnyShapeStyle(AppGradient.progressFill)
                                : AnyShapeStyle(AppGradient.cardSurface(tint: AppColor.accent))
                        )
                )
                .foregroundColor(AppColor.textPrimary)
        }
        .buttonStyle(.plain)
    }
}
