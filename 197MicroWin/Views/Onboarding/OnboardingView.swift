import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel

    init(viewModel: OnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 0) {
                header

                TabView(selection: $viewModel.currentPage) {
                    ForEach(viewModel.pages) { page in
                        OnboardingPageView(page: page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.25), value: viewModel.currentPage)

                footer
            }
        }
    }

    private var header: some View {
        HStack {
            Spacer()
            if !viewModel.isLastPage {
                Button("Skip", action: viewModel.skip)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(AppColor.textSecondary)
            }
        }
        .frame(height: 44)
        .padding(.horizontal, AppLayout.horizontalPadding)
        .padding(.top, 8)
    }

    private var footer: some View {
        VStack(spacing: 20) {
            OnboardingPageIndicator(
                count: viewModel.pages.count,
                currentIndex: viewModel.currentPage
            )

            AppPrimaryButton(
                title: viewModel.primaryButtonTitle,
                icon: viewModel.primaryButtonIcon,
                action: viewModel.advance
            )
        }
        .padding(.horizontal, AppLayout.horizontalPadding)
        .padding(.bottom, 36)
        .padding(.top, 12)
    }
}

// MARK: - Page

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 12)

            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(AppGradient.cardSurface(tint: page.tint))
                    .frame(height: 280)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(AppGradient.cardSheen(tint: page.tint))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(page.tint.opacity(0.35), lineWidth: 1)
                    )
                    .modifier(AppShadowModifier(elevation: .hero))

                if let imageName = page.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                        .overlay(
                            LinearGradient(
                                colors: [.clear, Color(hex: "0F1328").opacity(0.55)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                        )
                }

                VStack {
                    Spacer()
                    HStack(spacing: 10) {
                        Image(systemName: page.systemIcon)
                            .font(.title3.weight(.bold))
                            .foregroundColor(page.tint)
                            .frame(width: 44, height: 44)
                            .background(AppGradient.iconWell(tint: page.tint))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        Spacer()
                    }
                    .padding(16)
                }
                .frame(height: 280)
            }
            .padding(.horizontal, AppLayout.horizontalPadding)

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.title.weight(.bold))
                    .foregroundColor(AppColor.textPrimary)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.body)
                    .foregroundColor(AppColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, AppLayout.horizontalPadding + 4)

            Spacer(minLength: 24)
        }
    }
}

// MARK: - Page Indicator

private struct OnboardingPageIndicator: View {
    let count: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(
                        index == currentIndex
                            ? AnyShapeStyle(AppGradient.progressFill)
                            : AnyShapeStyle(AppColor.textSecondary.opacity(0.25))
                    )
                    .frame(width: index == currentIndex ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.25), value: currentIndex)
            }
        }
    }
}
