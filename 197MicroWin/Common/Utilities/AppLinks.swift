import Foundation

enum AppLinks {
    case privacyPolicy
    case termsOfUse

    var urlString: String {
        switch self {
        case .privacyPolicy:
            return "https://www.termsfeed.com/live/f1040162-f679-4972-b821-397064dfba1d"
        case .termsOfUse:
            return "https://www.termsfeed.com/live/5c0a87d0-7e09-45e8-b198-d21a6d378e5e"
        }
    }

    var url: URL? {
        URL(string: urlString)
    }
}
