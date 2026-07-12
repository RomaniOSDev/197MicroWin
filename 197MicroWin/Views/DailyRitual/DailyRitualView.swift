import SwiftUI

struct DailyRitualView: View {
    @StateObject private var viewModel: DailyRitualViewModel
    @FocusState private var isFocused: Bool

    init(viewModel: DailyRitualViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.step == .completion {
                RitualCompletionView(streak: viewModel.streakAfterCompletion, onDone: viewModel.finish)
            } else {
                ritualContent
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", action: viewModel.cancel)
                    .foregroundColor(AppColor.accent)
            }
        }
    }

    private var ritualContent: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 0) {
                StepProgressBar(
                    progress: viewModel.progress,
                    stepLabel: stepLabel
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        switch viewModel.step {
                        case .primaryWin:
                            stepHeader("What went well today?", subtitle: "Your main win is required")
                            templateScroll(forPrimary: true)
                            AppTextFieldCell(
                                label: "Main win",
                                placeholder: "Describe your win...",
                                text: $viewModel.primaryTitle,
                                focused: $isFocused
                            )
                            categoryPicker(selection: $viewModel.primaryCategory)

                        case .microWin:
                            stepHeader("Optional micro-win", subtitle: "A tiny extra victory — skip if none")
                            templateScroll(forPrimary: false)
                            AppTextFieldCell(
                                label: "Micro-win",
                                placeholder: "Small extra win...",
                                text: $viewModel.microTitle
                            )
                            categoryPicker(selection: $viewModel.microCategory)

                        case .reflection:
                            stepHeader("Why did this matter?", subtitle: "A short reflection anchors the win")
                            AppTextEditorCell(label: "Reflection", text: $viewModel.reflection, minHeight: 130)

                        case .moodAndMetrics:
                            stepHeader("Mood & impact", subtitle: "How did this win feel?")
                            MoodPickerView(selectedMood: $viewModel.selectedMood)
                                .padding(14)
                                .appListCard(tint: AppColor.accent, bordered: false)
                            WinMetricsPickerView(
                                winSize: $viewModel.winSize,
                                energy: $viewModel.energy,
                                impactScore: $viewModel.impactScore
                            )
                            .padding(14)
                            .appListCard(tint: AppColor.accent, bordered: false)

                        case .completion:
                            EmptyView()
                        }

                        navigationButtons
                    }
                    .padding(.horizontal, AppLayout.horizontalPadding)
                    .padding(.top, 16)
                    .padding(.bottom, 28)
                }
                .clearScrollBackground()
            }
        }
    }

    private var stepLabel: String {
        switch viewModel.step {
        case .primaryWin: return "Step 1 · Main win"
        case .microWin: return "Step 2 · Micro-win"
        case .reflection: return "Step 3 · Reflection"
        case .moodAndMetrics: return "Step 4 · Mood & impact"
        case .completion: return "Complete"
        }
    }

    @ViewBuilder
    private func templateScroll(forPrimary: Bool) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.templates.prefix(6)) { template in
                    FilterChip(title: template.title, isSelected: false) {
                        viewModel.applyTemplate(template, toPrimary: forPrimary)
                    }
                }
            }
        }
    }

    private func categoryPicker(selection: Binding<Category>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColor.textSecondary)
            Picker("Category", selection: selection) {
                ForEach(Category.allCases, id: \.self) { category in
                    Text("\(category.icon) \(category.rawValue)").tag(category)
                }
            }
            .pickerStyle(.menu)
            .padding(14)
            .appListCard(tint: Color(hex: selection.wrappedValue.color), bordered: false)
        }
    }

    private var navigationButtons: some View {
        HStack(spacing: 12) {
            if viewModel.step != .primaryWin {
                AppSecondaryButton(title: "Back", action: viewModel.previousStep)
            }
            AppPrimaryButton(
                title: viewModel.step == .moodAndMetrics ? "Complete Ritual" : "Continue",
                icon: "arrow.right",
                enabled: primaryButtonEnabled,
                action: primaryAction
            )
        }
    }

    private var primaryButtonEnabled: Bool {
        switch viewModel.step {
        case .primaryWin: return viewModel.isPrimaryValid
        case .microWin, .reflection: return true
        case .moodAndMetrics: return viewModel.isReadyToComplete
        case .completion: return false
        }
    }

    private func primaryAction() {
        if viewModel.step == .moodAndMetrics {
            viewModel.completeRitual()
        } else {
            viewModel.nextStep()
        }
    }

    private func stepHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title2.weight(.bold))
                .foregroundColor(AppColor.textPrimary)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(AppColor.textSecondary)
        }
    }
}
