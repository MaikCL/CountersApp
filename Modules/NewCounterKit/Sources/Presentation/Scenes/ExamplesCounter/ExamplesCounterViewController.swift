import UIKit
import Combine
import AltairMDKCommon

final class ExamplesCounterViewController: UIViewController {
    private(set) var viewModel: ExamplesCounterViewModelProtocol?
    private(set) lazy var innerView = ExamplesCounterView()
    private var cancellables = Set<AnyCancellable>()
    
    var dataSource: DataSource? = nil
    
    var examples: [ExampleModel] = [] {
        didSet {
            setupSnapshot()
        }
    }
    
    init(viewModel: ExamplesCounterViewModelProtocol) {
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
        setupDataSource()
        examples = setupExampleData()
        subscribeViewState()
    }

}

// MARK: Main ViewController Operations

extension ExamplesCounterViewController {
    
    func saveCounter(title: String) {
        viewModel?.createExampleCounter(title: title)
    }
    
    func dismissDialog() {
        viewModel?.dismissDialog()
    }
}

// MARK: Handle States

extension ExamplesCounterViewController {
    
    private func subscribeViewState() {
        viewModel?.statePublisher
            .receive(on: DispatchQueue.main).sink { [weak self] newState in
                guard let self = self else { return }
                if newState.isCreated { self.viewModel?.coordinator?.dismissExampleCounterScreen() }
                if let exception = newState.exception { self.showExceptionDialog(exception) }
            }
            .store(in: &cancellables)
    }
    
}
