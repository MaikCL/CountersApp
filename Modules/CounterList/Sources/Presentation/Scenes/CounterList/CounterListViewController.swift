import UIKit
import Design
import Combine
import AltairMDKCommon

final class CounterListViewController: UIViewController {
    private(set) var viewModel: CounterListViewModelProtocol?
    private(set) lazy var innerView = CounterListView()
    private var cancellables = Set<AnyCancellable>()

    private(set) var counterItems = [CounterModel]() {
        didSet {
            if counterItems.isEmpty { isEditing = false }
            editButtonItem.isEnabled = counterItems.isEmpty ? false : true
            updateCounterResumeInToolbar(counters: counterItems)
            applySnapshot(items: counterItems, animate: animateUpdate)
        }
    }
    
    private(set) var searchedItems = [CounterModel]() {
        didSet {
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
//        subscribeViewState()
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
    
}












// MARK: Handle States

//    private func subscribeViewState() {
//        viewModel?.statePublisher.receive(on: DispatchQueue.main).sink { [weak self] newState in
//            guard let self = self else { return }
//            if self.isSearchActive {
//                self.applySearchStateBehavior(state: newState.searchedCounters)
//            } else {
//                self.applyListStateBehavior(state: newState.counters)
//            }
//
//            if let exception = newState.exception {
//                self.applyExceptionStateBehavior(exception: exception)
//            }
//        }
//        .store(in: &cancellables)
//    }
//

//private extension CounterListViewController {
//    
//    func applyListStateBehavior(state: Loadable<[CounterModel]>) {
//        innerView.collectionView.isScrollEnabled = true
//        switch state {
//            case .neverLoaded:
//                counterItems = []
//                
//            case .loading:
//                if counterItems.isEmpty {
//                    innerView.collectionView.backgroundView = LoadingView()
//                    innerView.collectionView.isScrollEnabled = false
//                }
//                
//            case .loaded(let results):
//                counterItems = results
//                innerView.collectionView.backgroundView = .none
//                innerView.collectionView.isScrollEnabled = true
//                if innerView.refreshControl.isRefreshing { innerView.refreshControl.endRefreshing() }
//        }
//    }
//    
//    func applySearchStateBehavior(state: [CounterModel]) {
//        searchedItems = state
//    }
//    
//    func applyExceptionStateBehavior(exception: CounterException) {
//        switch exception {
//            case .noCountersYet:
//                let exceptionView = ExceptionView(exception: exception, actionButtonTitle: Locale.buttonTitleCreateACounter.localized)
//                exceptionView.setActionButton(selector: #selector(addButtonAction(_:)), sender: self)
//                innerView.collectionView.backgroundView = exceptionView
//                innerView.collectionView.isScrollEnabled = false
//
//            case .cantLoadCounters:
//                let exceptionView = ExceptionView(exception: exception, actionButtonTitle: Locale.buttonTitleRetry.localized)
//                exceptionView.setActionButton(selector: #selector(retryFetchButtonAction(_:)), sender: self)
//                innerView.collectionView.backgroundView = exceptionView
//                innerView.collectionView.isScrollEnabled = false
//
//            case .cantIncrementCounter(let counter):
//                retryActionAlert = .increment(id: counter.id)
//                setupAlertViewForUpdateFailed(counter: counter, exception: exception)
//
//            case  .cantDecrementCounter(let counter):
//                retryActionAlert = .decrement(id: counter.id)
//                setupAlertViewForUpdateFailed(counter: counter, exception: exception)
//
//            case .cantDeleteCounters(let counters):
//                retryActionAlert = .delete(ids: counters.map { $0.id })
//                setupAlertViewForUpdateFailed(exception: exception)
//
//            case .noSearchResults:
//                let exceptionView = ExceptionView(exception: exception)
//                innerView.collectionView.backgroundView = exceptionView
//                innerView.collectionView.isScrollEnabled = false
//                
//        }
//    }
//    
//}















extension CounterListViewController {
    
    
    
    
    
    
//
//    @objc func retryFetchButtonAction(_ sender: Any) {
//        viewModel?.fetchCounters()
//    }
    
//    @objc func addButtonAction(_ sender: Any)
    
//    @objc func actionButtonAction(_ sender: Any) {
//
//        viewModel?.coordinator?.coordinateToShareActionScreen(message: [countersInfo])
//    }
    
//    @objc func deleteButtonAction(_ sender: Any) {
//        var selectedIds = [String]()
//        innerView.collectionView.indexPathsForSelectedItems?.forEach { selectedIds.append(counterItems[$0.row].id) }
//        guard !selectedIds.isEmpty else { return }
//        let cancelAction = UIAlertAction(title: Locale.alertButtonCancel.localized, style: .cancel, handler: nil)
//        let deleteAction = UIAlertAction(title: Locale.alertButtonDelete.localized(with: selectedIds.count), style: .destructive) { _ in
//            self.viewModel?.deleteCounters(ids: selectedIds)
//        }
//        let deleteAlert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
//        deleteAlert.view.tintColor = Palette.accent.uiColor
//        deleteAlert.addAction(deleteAction)
//        deleteAlert.addAction(cancelAction)
//        self.present(deleteAlert, animated: true, completion: nil)
//    }
    
//    @objc func selectAllButtonAction(_ sender: Any) {
//        for row in 0..<innerView.collectionView.numberOfItems(inSection: Section.main.rawValue) {
//            innerView.collectionView.selectItem(at: IndexPath(row: row, section: Section.main.rawValue), animated: false, scrollPosition: .centeredHorizontally)
//        }
//    }
//
}


