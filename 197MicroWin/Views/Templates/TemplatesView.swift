import SwiftUI

struct TemplatesView: View {
    @StateObject private var viewModel: TemplatesViewModel

    init(viewModel: TemplatesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AppScrollScreen {
            VStack(spacing: AppLayout.sectionSpacing) {
                AppScreenTitleBar(emoji: "📋", title: "Win Templates")

                VStack(spacing: 12) {
                    AppSectionHeader(title: "Create Custom")
                    AppTextFieldCell(label: "Template title", placeholder: "Finished a workout...", text: $viewModel.newTitle)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(AppColor.textSecondary)
                        Picker("Category", selection: $viewModel.newCategory) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Text("\(category.icon) \(category.rawValue)").tag(category)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(14)
                        .appListCard(tint: Color(hex: viewModel.newCategory.color), bordered: false)
                    }

                    AppPrimaryButton(
                        title: "Add Template",
                        icon: "plus.circle.fill",
                        enabled: viewModel.canAdd,
                        action: viewModel.addTemplate
                    )
                }

                VStack(spacing: 10) {
                    AppSectionHeader(title: "All Templates")
                    ForEach(viewModel.templates) { template in
                        HStack(spacing: 14) {
                            CategoryIconBadge(category: template.category, size: 44)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(template.title)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(AppColor.textPrimary)
                                Text(template.isCustom ? "Custom" : "Built-in")
                                    .font(.caption)
                                    .foregroundColor(AppColor.textSecondary)
                            }
                            Spacer()
                            if template.isCustom {
                                Button(role: .destructive) {
                                    viewModel.delete(template)
                                } label: {
                                    Image(systemName: "trash.circle.fill")
                                        .font(.title3)
                                }
                            }
                        }
                        .padding(14)
                        .appListCard(tint: Color(hex: template.category.color), bordered: false)
                    }
                }
            }
        }
        .appPushedScreen(onBack: viewModel.goBack)
    }
}
