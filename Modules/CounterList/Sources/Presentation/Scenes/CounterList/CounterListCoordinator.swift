import UIKit
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
        let counterListViewController = CounterListViewController(viewModel: counterListViewModel)
        navigationController.setViewControllers([counterListViewController], animated:true)
    }
    
}
