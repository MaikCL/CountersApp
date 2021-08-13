import UIKit
import Combine
import AltairMDKCommon

final class CounterListViewController: UIViewController {
    private(set) var viewModel: CounterListViewModelProtocol?
    private(set) lazy var innerView = CounterListView()
    private var cancellables = Set<AnyCancellable>()
    
    var counterItems = [CounterModel]() {
        didSet {
            if counterItems.isEmpty { isEditing = false }
            editButtonItem.isEnabled = counterItems.isEmpty ? false : true
            updateCounterResumeInToolbar(counters: counterItems)
            applySnapshot(items: counterItems, animate: animateUpdate)
        }
    }
    
    var searchedItems = [CounterModel]() {
        didSet {
            if !searchedItems.isEmpty { innerView.hideBackgroundView() }
            applySnapshot(items: searchedItems, animate: animateUpdate)
        }
    }
    
    var isSearchActive = false
    var animateUpdate = true
    var retryAction: RetryAction?
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
        setupNavigationController()
        setupSearchController()
        configureDataSource()
        setupDelegates()
        subscribeViewState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCounters()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        innerView.isEditMode = editing
        navigationItem.rightBarButtonItem = editing ? setupSelectAllCounterButtonItem() : .none
        if editing {
            toolbarItems = setupToolbarEditMode()
        } else {
            toolbarItems = setupToolbar()
            updateCounterResumeInToolbar(counters: counterItems)
        }
    }
    
}

// MARK: Main ViewController Operations

extension CounterListViewController {
    
    func fetchCounters() {
        viewModel?.fetchCounters()
    }
    
    func createCounter() {
        viewModel?.coordinator?.coordinateToAddCounterScreen()
    }
    
    func deleteCounters(ids: [String]) {
        viewModel?.deleteCounters(ids: ids)
    }
    
    func shareCounters(message: [String]) {
        viewModel?.coordinator?.coordinateToShareActionScreen(message: message)
    }
    
    func incrementCounter(id: String) {
        viewModel?.incrementCounter(id: id)
    }
    
    func decrementCounter(id: String) {
        viewModel?.decrementCounter(id: id)
    }
    
    func searchCounter(term: String) {
        viewModel?.searchCounter(term: term)
    }
    
    func finishSearch() {
        viewModel?.finishSearch()
    }
    
}

// MARK: Handle States

extension CounterListViewController {
    
    private func subscribeViewState() {
        viewModel?.statePublisher
            .receive(on: DispatchQueue.main).sink { [weak self] newState in
                guard let self = self else { return }
                if self.isSearchActive {
                    self.applySearchStateBehavior(state: newState.searchedCounters)
                } else {
                    self.applyListStateBehavior(state: newState.counters)
                }
                guard let exception = newState.exception else { return }
                self.handleException(exception)
            }
            .store(in: &cancellables)
    }
    
}
