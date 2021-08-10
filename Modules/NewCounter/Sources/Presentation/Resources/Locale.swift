import Foundation

enum Locale: String {
    
    /// Create a counter
    case navigationBarTitle = "navigationBar.title"
    
    /// Create
    case navigationBack = "navigationBar.back"
    
    /// Save
    case buttonItemSave = "button.item.save"
    
    /// Cancel
    case buttonItemCancel = "button.item.cancel"

    /// Dismiss
    case alertButtonDismiss = "alert.button.dismiss"
    
    /// Couldn't create the counter
    case exceptionTitleCantCreateCounter = "exception.title.cantCreateCounter"
    
    /// The internet connection appears to be offline.
    case exceptionMessageCantCreateCounter = "exception.message.cantCreateCounter"
    
    /// Cups of coffe
    case textFieldHintExampleTitle = "textfield.hint.exampleTitle"

}

extension Locale {
    
    var localized: String {
        return NSLocalizedString(self.rawValue, bundle: .module, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
}
