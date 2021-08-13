import UIKit
import NewCounterKit
import AltairMDKCommon

protocol CounterListFlow {
    func coordinateToAddCounterScreen()
    func coordinateToShareActionScreen(message: [String])
}

final public class CounterListCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let counterListViewModel = CounterListViewModel()
        counterListViewModel.coordinator = self
        let counterListViewController = CounterListViewController(viewModel: counterListViewModel)
        navigationController.setViewControllers([counterListViewController], animated:true)
    }

}

extension CounterListCoordinator: CounterListFlow {
    
    func coordinateToAddCounterScreen() {
        let createCounterCoordinator = CreateCounterCoordinator(navigationController: navigationController)
        coordinate(to: createCounterCoordinator)
    }
    
    func coordinateToShareActionScreen(message: [String]) {
        guard let view = navigationController.view else { return }
        let shareSheet = UIActivityViewController(activityItems: message, applicationActivities: .none)
        if let popoverController = shareSheet.popoverPresentationController {
            popoverController.sourceView = navigationController.view
            popoverController.sourceRect = CGRect(x: view.bounds.maxX - 20.0, y: view.bounds.maxY - 20.0, width: 0, height: 0)
        }
        navigationController.present(shareSheet, animated: true)
    }
    
}
