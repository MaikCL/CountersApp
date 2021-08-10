import UIKit
import Design

extension CreateCounterViewController {
    
    func setupNavigationController() {
        title = Locale.navigationBarTitle.localized
        let backItem = UIBarButtonItem()
        backItem.title = Locale.navigationBack.localized
        navigationItem.largeTitleDisplayMode = .never
    }
    
}
