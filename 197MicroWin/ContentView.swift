import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator: AppCoordinator

    init() {
        _coordinator = StateObject(wrappedValue: AppCoordinator(services: AppServices()))
    }

    var body: some View {
        coordinator.start()
            .environmentObject(coordinator)
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
