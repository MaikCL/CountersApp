import Foundation

enum Locale: String {
    
    /// Counters
    case navigationBarTitle = "navigationBar.title"
    
    /// Search
    case searchBarPlaceholder = "searchBar.placeholder"

    /// Select All
    case buttonItemSelectAll = "button.item.selectAll"
    
    /// %i items \{U+2022} Counted %i times
    case toolbarCounterResume = "toolbar.counterResume"
    
    /// "Create a counter"
    case buttonTitleCreateACounter = "button.title.createACounter"
    
    /// Retry
    case buttonTitleRetry = "button.title.retry"
    
    /// Retry
    case alertButtonRetry = "alert.button.retry"
    
    /// Dismiss
    case alertButtonDismiss = "alert.button.dismiss"
    
    /// Delete %i counter
    case alertButtonDelete = "alert.button.delete"
    
    /// Cancel
    case alertButtonCancel = "alert.button.cancel"
    
    /// "No counters yet"
    case exceptionTitleNoCountersYet = "exception.title.noCountersYet"
    
    /// "Couldn't load the counters"
    case exceptionTitleCantLoad = "exception.title.cantLoad"
    
    /// "Could't delete the counter \"%@\"";
    case exceptionTitleCantDelete = "exception.title.cantDelete"
    
    /// "Couldn't update the \"%@\" counter to %@"
    case exceptionTitleCantUpdate = "exception.title.cantUpdate"
    
    /// "\"When I started counting my blessings, my whole life turned around.\"\n—Willie Nelson"
    case exceptionMessageNoCountersYet = "exception.message.noCountersYet"
    
    /// "The Internet connection appears to be offline";
    case exceptionMessageCantLoad = "exception.message.cantLoad"
    
    /// "The Internet connection appears to be offline";
    case exceptionMessageCantDelete = "exception.message.cantDelete"
    
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
