import Foundation

enum Locale: String {
    
    /// Counters
    case navigationBarTitle = "navigationBar.title"
    
    /// Search
    case searchBarPlaceholder = "searchBar.placeholder"
    
    /// "Could't delete the counter \"%@\""
    case exceptionCantDeleteTitle = "exception.title.cantDelete"
    
    /// Couldn't update the \"%@\" counter to %@
    case exceptionCantUpdateTitle = "exception.title.cantUpdate"
    
    /// Couldn't load the counters
    case exceptionCantLoadTitle = "exception.title.cantLoad"
    
    /// Select All
    case barButtonItemSelectAll = "buttonItem.title.selectAll"
    
    /// %i items \{U+2022} Counted %i times
    case toolbarCounterResume = "toolbar.counterResume"
     
}

extension Locale {
    
    var localized: String {
        return NSLocalizedString(self.rawValue, bundle: .module, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
}
