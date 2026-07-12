import SwiftUI

struct MotivationView: View {
    @StateObject private var viewModel: MotivationViewModel

    init(viewModel: MotivationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            AppBackgroundView()

            ScrollView {
                VStack(spacing: 24) {
                    Text("💡 Motivation")
                        .font(.title2.weight(.bold))
                        .foregroundColor(AppColor.textPrimary)
                        .padding(.top)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                title: "All",
                                isSelected: viewModel.selectedCategory == nil,
                                action: {
                                    viewModel.selectedCategory = nil
                                }
                            )

                            ForEach(Category.allCases, id: \.self) { category in
                                FilterChip(
                                    title: category.icon,
                                    isSelected: viewModel.selectedCategory == category,
                                    action: {
                                        if viewModel.selectedCategory == category {
                                            viewModel.selectedCategory = nil
                                        } else {
                                            viewModel.selectedCategory = category
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }

                    if let quote = viewModel.currentQuote {
                        VStack(spacing: 16) {
                            Text("✨ Quote of the Day")
                                .font(.headline)
                                .foregroundColor(AppColor.textSecondary)

                            Text("\"\(quote.text)\"")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(AppColor.textPrimary)
                                .multilineTextAlignment(.center)

                            Text("— \(quote.author)")
                                .font(.subheadline)
                                .foregroundColor(AppColor.textSecondary)

                            if let category = quote.category {
                                CategoryBadgeView(category: category)
                            }

                            Button(action: viewModel.refreshQuote) {
                                Label("New Quote", systemImage: "arrow.clockwise")
                                    .font(.subheadline)
                                    .foregroundColor(AppColor.accent)
                            }
                        }
                        .padding(20)
                        .appFloatingCard(tint: AppColor.accent)
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("All Quotes")
                            .font(.headline)
                            .foregroundColor(AppColor.textPrimary)
                            .padding(.horizontal)

                        ForEach(viewModel.filteredQuotes) { quote in
                            QuoteRow(quote: quote)
                                .padding(.horizontal)
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(.bottom)
            }
            .clearScrollBackground()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: viewModel.goBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(AppColor.accent)
                }
            }
        }
    }
}

struct QuoteRow: View {
    let quote: Quote

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\"\(quote.text)\"")
                .font(.subheadline)
                .foregroundColor(AppColor.textPrimary)
                .multilineTextAlignment(.leading)
            Text("— \(quote.author)")
                .font(.caption)
                .foregroundColor(AppColor.textSecondary)
            if let category = quote.category {
                CategoryBadgeView(category: category)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appListCard(tint: AppColor.accent, bordered: false)
    }
}
