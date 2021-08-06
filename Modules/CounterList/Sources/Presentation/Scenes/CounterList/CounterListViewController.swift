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
        setupSearchController()
        configureDataSource()
        setupTargets()
        setupDelegates()
        subscribeViewState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.fetchCounters()
    }
    
    private func subscribeViewState() {
        viewModel?.statePublisher.receive(on: DispatchQueue.main).sink { [weak self] newState in
            guard let self = self else { return }
            switch newState.counters {
                case .neverLoaded:
                    print("NEVER LOADED")
                    
                case .loading:
                    print("LOADING")
                    if self.counterItems.isEmpty { self.innerView.collectionView.backgroundView = LoadingView() }
                    
                case .loaded(let results):
                    print("LOADED")
                    self.counterItems = results
                    self.innerView.collectionView.backgroundView = .none
                    if self.innerView.refreshControl.isRefreshing { self.innerView.refreshControl.endRefreshing() }

            }
        }
        .store(in: &cancellables)
    }
    
}

extension CounterListViewController {
    
    @objc func refreshCounterList(_ sender: Any) {
        self.viewModel?.fetchCounters()
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
