import SwiftUI

struct AchievementFormView: View {
    @StateObject private var viewModel: AchievementFormViewModel
    @FocusState private var isFocused: Bool

    init(viewModel: AchievementFormViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            AppBackgroundView()

            ScrollView {
                VStack(spacing: 20) {
                    AppScreenTitleBar(
                        emoji: viewModel.isEditing ? "✏️" : "➕",
                        title: viewModel.isEditing ? "Edit Win" : "Add Win"
                    )

                    if !viewModel.templates.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Quick templates")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(AppColor.textSecondary)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.templates.prefix(6)) { template in
                                        FilterChip(title: template.title, isSelected: false) {
                                            viewModel.applyTemplate(template)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    AppTextFieldCell(
                        label: "Title *",
                        placeholder: "What did you accomplish?",
                        text: $viewModel.title,
                        focused: $isFocused
                    )

                    AppTextEditorCell(label: "Description", text: $viewModel.description, minHeight: 90)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(AppColor.textSecondary)
                        Picker("", selection: $viewModel.selectedCategory) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Text("\(category.icon) \(category.rawValue)").tag(category)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(14)
                        .appListCard(tint: Color(hex: viewModel.selectedCategory.color), bordered: false)
                    }

                    WinMetricsPickerView(
                        winSize: $viewModel.winSize,
                        energy: $viewModel.energy,
                        impactScore: $viewModel.impactScore
                    )
                    .padding(14)
                    .appListCard(tint: AppColor.accent, bordered: false)

                    MoodPickerView(selectedMood: $viewModel.selectedMood)
                        .padding(14)
                        .appListCard(tint: AppColor.accent, bordered: false)

                    AppTextEditorCell(label: "Why did this matter?", text: $viewModel.reflectionNote, minHeight: 70)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(AppColor.textSecondary)
                        DatePicker("", selection: $viewModel.date, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .tint(AppColor.accent)
                            .padding(10)
                            .appListCard(tint: AppColor.accent, bordered: false)
                    }

                    Toggle(isOn: $viewModel.isFavorite) {
                        Label("Add to Favorites", systemImage: "heart.fill")
                            .foregroundColor(AppColor.textPrimary)
                    }
                    .tint(AppColor.accent)
                    .padding(14)
                    .appListCard(tint: Color(hex: "FF6B6B"), bordered: false)

                    AppPrimaryButton(
                        title: viewModel.isEditing ? "Save Changes" : "Add Win",
                        icon: "checkmark.circle.fill",
                        enabled: viewModel.isFormValid,
                        action: viewModel.saveAchievement
                    )
                }
                .padding(.horizontal, AppLayout.horizontalPadding)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .clearScrollBackground()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", action: viewModel.cancel)
                    .foregroundColor(AppColor.accent)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isFocused = false }
                    .foregroundColor(AppColor.accent)
            }
        }
    }
}
