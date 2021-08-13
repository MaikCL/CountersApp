import UIKit
import DesignKit
import AltairMDKCommon

extension ExamplesCounterViewController {
    
    func showExceptionDialog(_ exception: Exception) {
        let dismissAction = UIAlertAction(title: Locale.alertButtonDismiss.localized, style: .default) { _ in
            self.dismissDialog()
        }
        let alert = UIAlertController(title: exception.errorTitle, message: exception.errorDescription, preferredStyle: .alert)
        alert.view.tintColor = Palette.accent.uiColor
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
}


// MARK: Delegates

extension ExamplesCounterViewController: ExamplesCounterViewCellDelegate {
    
    func didTapExampleCounter(title: String) {
        saveCounter(title: title)
    }
    
}
