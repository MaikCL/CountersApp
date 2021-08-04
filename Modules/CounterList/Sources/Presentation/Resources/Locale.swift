import Foundation

enum Locale: String {
    
    /// Counters
    case navigationBarTitle = "navigationBar.title"
    
}

extension Locale {
    var localized: String {
        return NSLocalizedString(self.rawValue, bundle: .module, comment: "")
    }
}
