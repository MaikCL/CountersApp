import UIKit

extension CounterListViewController {
    
    func setupNavigationBar() {
        self.title = Locale.navigationBarTitle.localized
        navigationItem.largeTitleDisplayMode = .always
    }
    
}
