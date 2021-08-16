import UIKit
import AltairMDKCommon

protocol ExamplesCounterFlow {
    func dismissExampleCounterScreen()
}

class ExamplesCounterCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let examplesCounterViewModel = ExamplesCounterViewModel()
        examplesCounterViewModel.coordinator = self
        let examplesCounterViewController = ExamplesCounterViewController(viewModel: examplesCounterViewModel)
        navigationController.pushViewController(examplesCounterViewController, animated: true)
    }

}

extension ExamplesCounterCoordinator: ExamplesCounterFlow {
    
    func dismissExampleCounterScreen() {
        navigationController.dismiss(animated: true)
    }
        
}
