import UIKit
import Design

// MARK: Handle States

extension CreateCounterViewController {
    
    func handleOccuredException(_ exception: NewCounterException?) {
        guard let exception = exception else { return }
        stopActivityIndicator()
        showExceptionAlert(exception: exception)
    }
    
    func handleCreateSuccess() {
        stopActivityIndicator()
        viewModel?.coordinator?.dismissCreateCounterScreen()
    }

}

// MARK: UI Operations

extension CreateCounterViewController {
    
    func startActivityIndicator() {
        innerView.startActivityIndicator()
    }
    
    func stopActivityIndicator() {
        innerView.stopActivityIndicator()
    }
    
    func showExceptionAlert(exception: NewCounterException) {
        if let currentAlert = self.presentedViewController as? UIAlertController {
            currentAlert.title = exception.errorTitle
            currentAlert.message = exception.errorDescription
            return
        }
        let dismissAction = UIAlertAction(title: Locale.alertButtonDismiss.localized, style: .cancel)
        let alert = UIAlertController(title: exception.errorTitle, message: exception.errorDescription, preferredStyle: .alert)
        alert.view.tintColor = Palette.accent.uiColor
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK:  View Delegates

extension CreateCounterViewController: CreateCounterViewDelegate {
    
    func isTitleValid(_ isValid: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isValid ? true : false
    }
    
}

