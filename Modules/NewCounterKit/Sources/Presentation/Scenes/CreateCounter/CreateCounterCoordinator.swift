import UIKit
import AltairMDKCommon

protocol CreateCounterFlow {
    func coordinateToExamplesScreen()
    func dismissCreateCounterScreen()
}

final public class CreateCounterCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var createCounterNavigationController: UINavigationController?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let createCounteViewModel = CreateCounterViewModel()
        createCounteViewModel.coordinator = self
        let createCounterViewController = CreateCounterViewController(viewModel: createCounteViewModel)
        createCounterNavigationController = UINavigationController(rootViewController: createCounterViewController)
        createCounterNavigationController?.modalPresentationStyle = .fullScreen
        navigationController.present(createCounterNavigationController!, animated: true)
    }
    
}

extension CreateCounterCoordinator: CreateCounterFlow {
    
    func coordinateToExamplesScreen() {
        // TODO
    }
    
    func dismissCreateCounterScreen() {
        navigationController.dismiss(animated: true)
    }

}
