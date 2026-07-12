import SwiftUI

struct PersonalMotivationView: View {
    @StateObject private var viewModel: PersonalMotivationViewModel

    init(viewModel: PersonalMotivationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AppScrollScreen {
            VStack(spacing: AppLayout.sectionSpacing) {
                AppScreenTitleBar(emoji: "💬", title: "Personal Motivation")

                if let message = viewModel.contextualMessage {
                    InsightMessageCell(
                        icon: "sparkles",
                        title: "Contextual message",
                        message: message
                    )
                }

                VStack(spacing: 12) {
                    AppSectionHeader(title: "Add Phrase")
                    AppTextFieldCell(
                        label: "Your words of support",
                        placeholder: "I am capable of more than I think...",
                        text: $viewModel.newPhrase
                    )
                    AppPrimaryButton(title: "Save Phrase", icon: "heart.fill", action: viewModel.addPhrase)
                }

                if viewModel.phrases.isEmpty {
                    EmptyStateView(
                        icon: "💬",
                        title: "No Phrases Yet",
                        message: "Write personal phrases that motivate you",
                        buttonTitle: "",
                        action: {}
                    )
                } else {
                    VStack(spacing: 10) {
                        AppSectionHeader(title: "Your Phrases")
                        ForEach(viewModel.phrases) { phrase in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "quote.opening")
                                    .foregroundColor(AppColor.accent)
                                Text(phrase.text)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(AppColor.textPrimary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Button(role: .destructive) {
                                    viewModel.delete(phrase)
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.caption)
                                }
                            }
                            .padding(14)
                            .appListCard(tint: AppColor.accent, bordered: false)
                        }
                    }
                }
            }
        }
        .appPushedScreen(onBack: viewModel.goBack)
        .onAppear { viewModel.load() }
    }
}
