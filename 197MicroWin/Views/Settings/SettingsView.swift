import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @State private var showResetAlert = false

    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AppScrollScreen {
            VStack(spacing: AppLayout.sectionSpacing) {
                AppScreenTitleBar(emoji: "⚙️", title: "Settings")

                VStack(spacing: 12) {
                    AppSectionHeader(title: "General")
                    ListMenuCell(
                        icon: "star.fill",
                        iconTint: Color(hex: "FFD93D"),
                        title: "Rate Us",
                        subtitle: "Enjoying the app? Leave a review",
                        action: viewModel.rateApp
                    )
                    ListMenuCell(
                        icon: "hand.raised.fill",
                        iconTint: AppColor.accent,
                        title: "Privacy Policy",
                        subtitle: "How we handle your data",
                        action: viewModel.openPrivacyPolicy
                    )
                    ListMenuCell(
                        icon: "doc.text.fill",
                        iconTint: Color(hex: "6C5CE7"),
                        title: "Terms of Use",
                        subtitle: "Rules for using the app",
                        action: viewModel.openTermsOfUse
                    )
                }

                VStack(spacing: 12) {
                    AppSectionHeader(title: "Data")
                    ListMenuCell(
                        icon: "trash.fill",
                        iconTint: Color(hex: "FF6B6B"),
                        title: "Reset All Data",
                        subtitle: "Delete wins, stats, rituals and phrases",
                        action: { showResetAlert = true }
                    )
                }

                VStack(spacing: 8) {
                    Text("Version 1.0")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppColor.textSecondary)
                    Text("Built for daily win awareness")
                        .font(.caption2)
                        .foregroundColor(AppColor.textSecondary.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
            }
        }
        .appPushedScreen(onBack: viewModel.goBack)
        .alert("Reset all data?", isPresented: $showResetAlert) {
            Button("Reset", role: .destructive, action: viewModel.resetAllData)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("All wins and statistics will be permanently deleted")
        }
    }
}
