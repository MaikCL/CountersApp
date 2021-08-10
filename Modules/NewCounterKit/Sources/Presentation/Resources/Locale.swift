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
