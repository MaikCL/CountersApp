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
        let shareSheet = UIActivityViewController(activityItems: message, applicationActivities: .none)
        navigationController.present(shareSheet, animated: true, completion: nil)
    }
    
}
