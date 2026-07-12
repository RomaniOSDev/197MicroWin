import Foundation

final class QuoteService {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol = UserDefaultsStorageService()) {
        self.storageService = storageService
    }

    func getQuotes() -> [Quote] {
        var quotes: [Quote] = storageService.load(forKey: StorageKeys.quotes)
        if quotes.isEmpty {
            quotes = Quote.defaultQuotes
            storageService.save(quotes, forKey: StorageKeys.quotes)
        }
        return quotes
    }

    func getDailyQuote() -> Quote? {
        let quotes = getQuotes().filter { !$0.isUsed }
        if quotes.isEmpty {
            var allQuotes = getQuotes()
            for index in allQuotes.indices {
                allQuotes[index].isUsed = false
            }
            storageService.save(allQuotes, forKey: StorageKeys.quotes)
            return allQuotes.randomElement()
        }
        return quotes.randomElement()
    }

    func markQuoteAsUsed(_ quoteId: UUID) {
        var quotes = getQuotes()
        if let index = quotes.firstIndex(where: { $0.id == quoteId }) {
            quotes[index].isUsed = true
            storageService.save(quotes, forKey: StorageKeys.quotes)
        }
    }

    func getQuote(for category: Category?) -> Quote? {
        var quotes = getQuotes().filter { !$0.isUsed }
        if let category {
            quotes = quotes.filter { $0.category == category }
        }
        if quotes.isEmpty {
            var allQuotes = getQuotes()
            for index in allQuotes.indices {
                allQuotes[index].isUsed = false
            }
            storageService.save(allQuotes, forKey: StorageKeys.quotes)
            return allQuotes.filter { $0.category == category }.randomElement() ?? allQuotes.randomElement()
        }
        return quotes.randomElement()
    }
}
