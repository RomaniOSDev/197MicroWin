import SwiftUI

struct AppSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search..."

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColor.accent)
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .foregroundColor(AppColor.textPrimary)
            if !text.isEmpty {
                Button { text = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColor.textSecondary)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .appFloatingCard(tint: AppColor.accent)
    }
}

struct AppTextFieldCell: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var focused: FocusState<Bool>.Binding?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColor.textSecondary)

            Group {
                if let focused {
                    TextField(placeholder, text: $text).focused(focused)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .textFieldStyle(.plain)
            .foregroundColor(AppColor.textPrimary)
            .padding(14)
            .appListCard(tint: AppColor.accent)
        }
    }
}

struct AppTextEditorCell: View {
    let label: String
    @Binding var text: String
    var minHeight: CGFloat = 100

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColor.textSecondary)

            TextEditor(text: $text)
                .frame(minHeight: minHeight)
                .scrollContentBackground(.hidden)
                .foregroundColor(AppColor.textPrimary)
                .padding(10)
                .appListCard(tint: AppColor.accent)
        }
    }
}

struct AppPrimaryButton: View {
    let title: String
    var icon: String?
    var enabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon) }
                Text(title)
            }
            .font(.headline.weight(.semibold))
            .foregroundColor(AppColor.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppGradient.primaryButton(enabled: enabled))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(enabled ? 0.2 : 0), lineWidth: 1)
                    )
            )
            .modifier(AppShadowModifier(elevation: enabled ? .floating : .flat))
        }
        .disabled(!enabled)
    }
}

struct AppSecondaryButton: View {
    let title: String
    var icon: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon) }
                Text(title)
            }
            .font(.headline.weight(.semibold))
            .foregroundColor(AppColor.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .appCard(tint: AppColor.accent, bordered: true, elevation: .raised)
        }
    }
}

struct AppDestructiveButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: "trash")
                .font(.headline.weight(.semibold))
                .foregroundColor(Color(hex: "FF6B6B"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .appCard(tint: Color(hex: "FF6B6B"), bordered: true, elevation: .raised)
        }
    }
}

struct StepProgressBar: View {
    let progress: Double
    let stepLabel: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(stepLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(AppColor.textSecondary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption.weight(.bold))
                    .foregroundColor(AppColor.accent)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(hex: "141C30"))
                    Capsule()
                        .fill(AppGradient.progressFill)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, AppLayout.horizontalPadding)
        .padding(.vertical, 10)
        .appFloatingCard(tint: AppColor.accent)
    }
}

struct AppProgressTrack: View {
    let progress: Double
    var height: CGFloat = 8

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color(hex: "141C30"))
                Capsule()
                    .fill(AppGradient.progressFill)
                    .frame(width: geo.size.width * min(1, max(0, progress)))
            }
        }
        .frame(height: height)
    }
}
