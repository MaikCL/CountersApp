import UIKit
import Combine

final class CounterListViewController: UIViewController {
    private var viewModel: CounterListViewModelProtocol?
    private var cancellables = Set<AnyCancellable>()
    private var animateSnapshot = true

    lazy var innerView = CounterListView()
    
    private(set) var counterItems: [CounterModel] = [] {
        didSet {
            applySnapshot(animate: animateSnapshot)
            animateSnapshot = false
        }
    }
    
    var dataSource: DataSource?
    
    init(viewModel: CounterListViewModelProtocol) {
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
        setupNavigationBar()
        configureDataSource()
        subscribeViewState()
        viewModel?.fetchCounters()
    }
    
    private func subscribeViewState() {
        viewModel?.statePublisher.receive(on: DispatchQueue.main).sink { [weak self] newState in
            guard let self = self else { return }
            switch newState.counters {
                case .neverLoaded:
                    print("NEVER LOADED")
                    
                case .loading:
                    self.innerView.collectionView.backgroundView = LoadingView()
                    print("LOADING")
                    
                case .loaded(let results):
                    self.counterItems = results
                    self.innerView.collectionView.backgroundView = .none
            }
        }
        .store(in: &cancellables)
    }
    
}

// MARK: Delegates

extension CounterListViewController: CounterCellViewDelegate {
    
    func didTapCounterIncremented(id: String) {
        animateSnapshot = false
        viewModel?.incrementCounter(id: id)
    }
    
    func didTapCounterDecremented(id: String) {
        animateSnapshot = false
        viewModel?.decrementCounter(id: id)
    }
    
}
