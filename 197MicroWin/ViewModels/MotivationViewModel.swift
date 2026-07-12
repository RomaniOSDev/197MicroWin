import SwiftUI
import Combine

@MainActor
final class MotivationViewModel: ObservableObject {
    @Published var currentQuote: Quote?
    @Published var quotes: [Quote] = []
    @Published var selectedCategory: Category?

    private let quoteService: QuoteService
    private let coordinator: AppCoordinator

    var filteredQuotes: [Quote] {
        if let selectedCategory {
            return quotes.filter { $0.category == selectedCategory }
        }
        return quotes
    }

    init(quoteService: QuoteService, coordinator: AppCoordinator) {
        self.quoteService = quoteService
        self.coordinator = coordinator
        loadData()
    }

    func loadData() {
        quotes = quoteService.getQuotes()
        currentQuote = quoteService.getDailyQuote()
    }

    func refreshQuote() {
        if let quote = currentQuote {
            quoteService.markQuoteAsUsed(quote.id)
        }
        currentQuote = quoteService.getQuote(for: selectedCategory)
    }

    func goBack() {
        coordinator.pop()
    }
}
