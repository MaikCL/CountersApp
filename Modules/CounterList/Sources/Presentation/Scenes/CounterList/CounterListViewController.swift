import UIKit
import Combine
import AltairMDKCommon

final class CounterListViewController: UIViewController {
    private var viewModel: CounterListViewModelProtocol?
    private var cancellables = Set<AnyCancellable>()
    private var animateUpdate = true

    lazy var innerView = CounterListView()
    
    private(set) var counterItems = [CounterModel]() {
        didSet {
            editButtonItem.isEnabled = counterItems.isEmpty ? false : true
            updateCounterResumeToolbar(counters: counterItems)
            applySnapshot(items: counterItems, animate: animateUpdate)
        }
    }
    
    private(set) var searchedItems = [CounterModel]() {
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
        setupNavigationComponents()
        setupSearchController()
        configureDataSource()
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
            // Specially change update status to cell when update fail
        }
        .store(in: &cancellables)
    }
    
    func applyListStateBehavior(state: Loadable<[CounterModel]>) {
        switch state {
            case .neverLoaded:
                break
                
            case .loading:
                if counterItems.isEmpty { innerView.collectionView.backgroundView = LoadingView() }
                
            case .loaded(let results):
                counterItems = results
                innerView.collectionView.backgroundView = .none
                if innerView.refreshControl.isRefreshing { innerView.refreshControl.endRefreshing() }
        }
    }
    
    func applySearchStateBehavior(state: [CounterModel]) {
        searchedItems = state
    }
    
}

extension CounterListViewController: CounterListViewDelegate {
    
    func didRefreshCounterList() {
        self.viewModel?.fetchCounters()
    }
    
}

extension CounterListViewController {
    
    @objc func addButtonAction(_ sender: Any) {
        // TODO: Make the AddCounter module
    }
    
    @objc func actionButtonAction(_ sender: Any) {
        var countersSelected = [String]()
        innerView.collectionView.indexPathsForSelectedItems?.forEach { indexPath in
            let counter = counterItems[indexPath.row]
            countersSelected.append("\(counter.count) x \(counter.title)")
        }

        print("")
        // TODO: Coordinate to ActivityVC
    }
    
    @objc func deleteButtonAction(_ sender: Any) {
        var countersSelected = [String]()
        innerView.collectionView.indexPathsForSelectedItems?.forEach { countersSelected.append(counterItems[$0.row].id) }
        countersSelected.forEach { viewModel?.deleteCounter(id: $0) }
    }
    
    @objc func selectAllButtonAction(_ sender: Any) {
        for row in 0..<innerView.collectionView.numberOfItems(inSection: Section.main.rawValue) {
            innerView.collectionView.selectItem(at: IndexPath(row: row, section: Section.main.rawValue), animated: false, scrollPosition: .centeredHorizontally)
        }
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
