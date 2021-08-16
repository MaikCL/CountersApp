import Foundation

enum Locale: String {
    
    /// "No counters yet"
    case exceptionTitleNoCountersYet = "exception.title.noCountersYet"
    
    /// "Couldn't load the counters"
    case exceptionTitleCantLoad = "exception.title.cantLoad"
    
    /// "Could't delete the counter \"%@\"";
    case exceptionTitleCantDelete = "exception.title.cantDelete"
    
    /// Couldn't create the counter
    case exceptionTitleCantCreate = "exception.title.cantCreate"
    
    /// "Couldn't update the \"%@\" counter to %@"
    case exceptionTitleCantUpdate = "exception.title.cantUpdate"
    
    /// "\"When I started counting my blessings, my whole life turned around.\"\n—Willie Nelson"
    case exceptionMessageNoCountersYet = "exception.message.noCountersYet"
    
    /// "The Internet connection appears to be offline";
    case exceptionMessageCantLoad = "exception.message.cantLoad"
    
    /// "The Internet connection appears to be offline";
    case exceptionMessageCantDelete = "exception.message.cantDelete"
    
    /// The internet connection appears to be offline.
    case exceptionMessageCantCreate = "exception.message.cantCreate"

    /// "The Internet connection appears to be offline"
    case exceptionMessageCantUpdate = "exception.message.cantUpdate"
    
    /// No Results
    case exceptionMessageNoSearchResult = "exception.message.noSearchResult"
    
}

extension Locale {
    
    var localized: String {
        return NSLocalizedString(self.rawValue, bundle: .module, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
}
