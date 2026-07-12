import Foundation

final class PersonalMotivationService {
    private let storageService: StorageServiceProtocol
    private let statsEngine: StatsEngine

    init(storageService: StorageServiceProtocol, statsEngine: StatsEngine) {
        self.storageService = storageService
        self.statsEngine = statsEngine
    }

    func getPhrases() -> [PersonalPhrase] {
        storageService.load(forKey: StorageKeys.personalPhrases)
    }

    func addPhrase(_ text: String) {
        var phrases = getPhrases()
        phrases.append(PersonalPhrase(id: UUID(), text: text, createdAt: Date()))
        storageService.save(phrases, forKey: StorageKeys.personalPhrases)
    }

    func deletePhrase(_ phrase: PersonalPhrase) {
        var phrases = getPhrases()
        phrases.removeAll { $0.id == phrase.id }
        storageService.save(phrases, forKey: StorageKeys.personalPhrases)
    }

    func randomPhrase() -> PersonalPhrase? {
        getPhrases().randomElement()
    }

    func contextualMessage() -> String? {
        let achievements = statsEngine.achievements()
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        let recent = achievements.filter { $0.date >= weekAgo && !$0.isMicroWin }

        if let top = recent.max(by: { $0.impactScore < $1.impactScore }) {
            return "Last week \"\(top.title)\" made a difference. Log one today."
        }

        if let phrase = randomPhrase() {
            return phrase.text
        }

        return nil
    }
}
