import UIKit
import Design
import Combine
import AltairMDKCommon

final class CounterListViewController: UIViewController {
    
    private enum RetryAction {
        case increment(id: String)
        case decrement(id: String)
    }
    
    private var viewModel: CounterListViewModelProtocol?
    private var cancellables = Set<AnyCancellable>()
    private var animateUpdate = true
    private var retryActionAlert: RetryAction?

    lazy var innerView = CounterListView()
    
    private(set) var counterItems = [CounterModel]() {
        didSet {
            if counterItems.isEmpty { isEditing = false }
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
            
            if let exception = newState.exception {
                self.applyExceptionStateBehavior(exception: exception)
            }
        }
        .store(in: &cancellables)
    }
    
}

// MARK: Handle States

private extension CounterListViewController {
    
    func applyListStateBehavior(state: Loadable<[CounterModel]>) {
        innerView.collectionView.isScrollEnabled = true
        switch state {
            case .neverLoaded:
                break
                
            case .loading:
                if counterItems.isEmpty {
                    innerView.collectionView.backgroundView = LoadingView()
                    innerView.collectionView.isScrollEnabled = false
                }
                
            case .loaded(let results):
                counterItems = results
                innerView.collectionView.backgroundView = .none
                innerView.collectionView.isScrollEnabled = true
                if innerView.refreshControl.isRefreshing { innerView.refreshControl.endRefreshing() }
        }
    }
    
    func applySearchStateBehavior(state: [CounterModel]) {
        searchedItems = state
    }
    
    func applyExceptionStateBehavior(exception: CounterException) {
        switch exception {
            case .noCountersYet:
                let exceptionView = ExceptionView(exception: exception, actionButtonTitle: Locale.buttonTitleCreateACounter.localized)
                exceptionView.setActionButton(selector: #selector(addButtonAction(_:)), sender: self)
                innerView.collectionView.backgroundView = exceptionView
                innerView.collectionView.isScrollEnabled = false

            case .cantLoadCounters:
                let exceptionView = ExceptionView(exception: exception, actionButtonTitle: Locale.buttonTitleRetry.localized)
                exceptionView.setActionButton(selector: #selector(retryFetchButtonAction(_:)), sender: self)
                innerView.collectionView.backgroundView = exceptionView
                innerView.collectionView.isScrollEnabled = false

            case .cantIncrementCounter(let counter):
                retryActionAlert = .increment(id: counter.id)
                setupAlertViewForUpdateFailed(counter: counter, exception: exception)

            case  .cantDecrementCounter(let counter):
                print("apply decrement")
                retryActionAlert = .decrement(id: counter.id)
                setupAlertViewForUpdateFailed(counter: counter, exception: exception)

            case .cantDeleteCounters:
                print("cant delete")

            case .noSearchResults:
                print("no search")

        }
    }
    
}

extension CounterListViewController: CounterListViewDelegate {
    
    func didRefreshCounterList() {
        self.viewModel?.fetchCounters()
    }
    
}

extension CounterListViewController {
    
    func retryUpdateButtonAction() {
        guard let retryAction = retryActionAlert else { return }
        switch retryAction {
            case .increment(let id):
                viewModel?.incrementCounter(id: id)
            case .decrement(let id):
                viewModel?.decrementCounter(id: id)
        }
        retryActionAlert = .none
    }
    
    @objc func retryFetchButtonAction(_ sender: Any) {
        viewModel?.fetchCounters()
    }
    
    @objc func addButtonAction(_ sender: Any) {
        // TODO: Make the AddCounter module
    }
    
    @objc func actionButtonAction(_ sender: Any) {
        var countersInfo = [String]()
        innerView.collectionView.indexPathsForSelectedItems?.forEach { indexPath in
            let counter = counterItems[indexPath.row]
            countersInfo.append("\(counter.count) x \(counter.title)")
        }
        // TODO: Coordinate to ActivityVC
    }
    
    @objc func deleteButtonAction(_ sender: Any) {
        var selectedIds = [String]()
        innerView.collectionView.indexPathsForSelectedItems?.forEach { selectedIds.append(counterItems[$0.row].id) }
        viewModel?.deleteCounters(ids: selectedIds)
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
