import UIKit
import Combine
import AltairMDKCommon

final class CounterListViewController: UIViewController {
    private var viewModel: CounterListViewModelProtocol?
    private var cancellables = Set<AnyCancellable>()
    private var animateUpdate = true

    lazy var innerView = CounterListView()
    
    private(set) var counterItems: [CounterModel] = [] {
        didSet {
            applySnapshot(items: counterItems, animate: animateUpdate)
        }
    }
    
    private(set) var searchedItems: [CounterModel] = [] {
        didSet {
            applySnapshot(items: searchedItems, animate: animateUpdate)
        }
    }
    
    var dataSource: DataSource?
    var isSearchActive = false
    
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
            if self.isSearchActive {
                self.applySearchStateBehavior(state: newState.searchedCounters)
            } else {
                self.applyListStateBehavior(state: newState.counters)
            }
            
            // TODO: Missing Exception behavior
        }
        .store(in: &cancellables)
    }
    
    func applyListStateBehavior(state: Loadable<[CounterModel]>) {
        switch state {
            case .neverLoaded:
                print("NEVER LOADED")
                
            case .loading:
                print("LOADING")
                if counterItems.isEmpty { innerView.collectionView.backgroundView = LoadingView() }
                
            case .loaded(let results):
                print("LOADED")
                counterItems = results
                innerView.collectionView.backgroundView = .none
                if innerView.refreshControl.isRefreshing { innerView.refreshControl.endRefreshing() }
        }
    }
    
    func applySearchStateBehavior(state: [CounterModel]) {
        searchedItems = state
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
        animateUpdate = false
        viewModel?.incrementCounter(id: id)
    }
    
    func didTapCounterDecremented(id: String) {
        animateUpdate = false
        viewModel?.decrementCounter(id: id)
    }
    
}

extension CounterListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let term = searchController.searchBar.text, !term.isEmpty, !counterItems.isEmpty else {
            applySnapshot(items: counterItems)
            return
        }
        animateUpdate = true
        viewModel?.searchCounter(term: term)
    }
    
}

extension CounterListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = .none
        isSearchActive = false
        viewModel?.finishSearch()
    }
    
}
