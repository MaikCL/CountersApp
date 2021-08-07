import Foundation

enum Locale: String {
    
    /// Counters
    case navigationBarTitle = "navigationBar.title"
    
    /// Search
    case searchBarPlaceholder = "searchBar.placeholder"
    
    /// "Could't delete the counter \"%@\""
    case exceptionCantDeleteTitle = "exception.cantDelete.title"
    
    /// Couldn't update the \"%@\" counter to %@
    case exceptionCantUpdateTitle = "exception.cantUpdate.title"
    
    /// Couldn't load the counters
    case exceptionCantLoadTitle = "exception.cantLoad.title"
    
    /// Select All
    case barButtonItemSelectAll = "barButtonItem.selectAll.title"
     
}

extension Locale {
    
    var localized: String {
        return NSLocalizedString(self.rawValue, bundle: .module, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
}
