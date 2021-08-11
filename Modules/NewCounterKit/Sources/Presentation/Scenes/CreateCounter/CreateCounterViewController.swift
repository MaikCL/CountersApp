import UIKit
import Combine

final class CreateCounterViewController: UIViewController {
    private(set) var viewModel: CreateCounterViewModelProtocol?
    private(set) lazy var innerView = CreateCounterView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CreateCounterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = innerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupDelegates()
        subscribeViewState()
    }
    
}

extension CreateCounterViewController {
    
    func saveCounter(title: String) {
        viewModel?.createCouter(title: title)
    }
    
    func openExamplesCounterScreen() {
        viewModel?.coordinator?.coordinateToExamplesScreen()
    }
    
    func dismissScreen() {
        viewModel?.coordinator?.dismissCreateCounterScreen()
    }
    
}

extension CreateCounterViewController {
    
    private func subscribeViewState() {
        viewModel?.statePublisher.receive(on: DispatchQueue.main).sink { [weak self] newState in
            guard let self = self else { return }
            if newState.isCreated { self.handleCreateSuccess() }
            self.handleCreatingInProgress(newState.isCreating)
            self.handleOccuredException(newState.exception)
        }
        .store(in: &cancellables)
    }
    
}
