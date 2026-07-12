import SwiftUI

extension View {
    func clearScrollBackground() -> some View {
        scrollContentBackground(.hidden)
            .background(Color.clear)
    }

    func appScreenBackground() -> some View {
        ZStack {
            AppBackgroundView()
            self
        }
    }

    func appPushedScreen(onBack: @escaping () -> Void, backTitle: String = "Back") -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .toolbar {
                AppBackToolbar(title: backTitle, action: onBack)
            }
    }
}

struct AppScrollScreen<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            AppBackgroundView()
            ScrollView {
                content()
                    .padding(.horizontal, AppLayout.horizontalPadding)
                    .padding(.top, 12)
                    .padding(.bottom, 28)
            }
            .clearScrollBackground()
        }
    }
}
