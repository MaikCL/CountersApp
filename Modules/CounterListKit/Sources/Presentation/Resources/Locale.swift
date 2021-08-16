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
    
    /// Delete %i counters
    case alertButtonDeletes = "alert.button.deletes"
    
    /// Cancel
    case alertButtonCancel = "alert.button.cancel"
    
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
