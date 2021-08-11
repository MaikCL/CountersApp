import UIKit
import DesignKit
import CounterKit
import AltairMDKCommon

extension CounterListViewController {
    
    func applySearchStateBehavior(state: [CounterModel]) {
        searchedItems = state
    }
    
    func applyListStateBehavior(state: Loadable<[CounterModel]>) {
        innerView.collectionView.isScrollEnabled = true
        switch state {
            case .neverLoaded:
                counterItems = []
                
            case .loading:
                if counterItems.isEmpty {
                    showLoadingView()
                }
                
            case .loaded(let results):
                counterItems = results
                hideLoadingView()
        }
    }
    
    func handleException(_ exception: Exception) {
        if let counterException = exception as? CounterException {
            self.handleCounterException(counterException)
        } else {
            self.handleGenericException(exception)
        }
    }
    
    func handleCounterException(_ exception: CounterException) {
        switch exception {
            case .noCountersYet:
                retryAction = .create
                showNoCountersExceptionView()
                
            case .noSearchResults:
                showSearchNoResultsExceptionView()
                
            case .cantLoadCounters:
                retryAction = .fetch
                showCantLoadCountersExceptionView()
                
            case .cantIncrementCounter(let counter):
                retryAction = .increment(id: counter.id)
                showCantUpdateCounterExceptionAlert(exception, counter: counter)
                
            case .cantDecrementCounter(let counter):
                retryAction = .decrement(id: counter.id)
                showCantUpdateCounterExceptionAlert(exception, counter: counter)
                
            case .cantDeleteCounters(let counters):
                retryAction = .delete(ids: counters.map { $0.id })
                showCantDeleteCounterExceptionAlert(exception)
                
            default: return
        }
        
    }
    
    func handleGenericException(_ exception: Exception) {
        showExceptionView(exception)
    }
    
}

extension CounterListViewController {
    
    func showLoadingView() {
        innerView.showListLoading()
    }
    
    func hideLoadingView() {
        innerView.hideBackgroundView()
        innerView.endRefreshAnimation()
    }
    
    func showNoCountersExceptionView() {
        let buttonTitle = Locale.buttonTitleCreateACounter.localized
        let view = ExceptionView(exception: CounterException.noCountersYet, actionButtonTitle: buttonTitle)
        view.delegate = self
        innerView.showBackgroundView(view)
        innerView.endRefreshAnimation()
    }
    
    func showCantLoadCountersExceptionView() {
        let buttonTitle = Locale.buttonTitleRetry.localized
        let view = ExceptionView(exception: CounterException.cantLoadCounters, actionButtonTitle: buttonTitle)
        view.delegate = self
        innerView.showBackgroundView(view)
        innerView.endRefreshAnimation()
    }
    
    func showSearchNoResultsExceptionView() {
        let view = ExceptionView(exception: CounterException.noSearchResults)
        innerView.showBackgroundView(view)
    }
    
    func showExceptionView(_ exception: Exception) {
        let view = ExceptionView(exception: exception)
        innerView.showBackgroundView(view)
    }
    
    func showCantDeleteCounterExceptionAlert(_ exception: Exception) {
        let retryAction = UIAlertAction(title: Locale.alertButtonRetry.localized, style: .cancel) { _ in
            self.executeRetryAction()
        }
        let dismissAction = UIAlertAction(title: Locale.alertButtonDismiss.localized, style: .default)
        presentAlertDialog(title: exception.errorTitle, message: exception.localizedDescription, retryAction, dismissAction)
    }
    
    func showCantUpdateCounterExceptionAlert(_ exception: Exception, counter: Counter) {
        let retryAction = UIAlertAction(title: Locale.alertButtonRetry.localized, style: .cancel) { _ in
            self.executeRetryAction()
        }
        let dismissAction = UIAlertAction(title: Locale.alertButtonDismiss.localized, style: .default) { _ in
            guard let counterIndex = self.counterItems.firstIndex(where: { $0.id == counter.id }) else { return }
            let counterItemRow = IndexPath(row: Int(counterIndex), section: Section.main.rawValue)
            self.innerView.getCell(at: counterItemRow)?.setUpdateFinish()
        }
        presentAlertDialog(title: exception.errorTitle, message: exception.localizedDescription, retryAction, dismissAction)
    }
    
    func updateCounterResumeInToolbar(counters: [CounterModel]) {
        guard
            let counterResumeItemIndex = toolbarItems?.firstIndex(where: { $0.tag == 1 }),
            let toolbarResumeItem = toolbarItems?[counterResumeItemIndex],
            let resumeLabel = toolbarResumeItem.customView as? UILabel
        else { return }
        
        if !counters.isEmpty {
            let accumulatedCount = counters.compactMap { Int($0.count) }.reduce(0, +)
            resumeLabel.text = Locale.toolbarCounterResume.localized(with: counters.count, accumulatedCount)
            resumeLabel.sizeToFit()
        } else {
            resumeLabel.text = ""
        }
    }
    
}

// MARK: Events Actions

extension CounterListViewController {
    
    enum RetryAction {
        case fetch
        case create
        case delete(ids: [String])
        case increment(id: String)
        case decrement(id: String)
    }
    
    func executeRetryAction() {
        guard let action = retryAction else { return }
        retryAction = .none
        switch action {
            case .fetch: fetchCounters()
            case .create: createCounter()
            case .delete(let ids): deleteCounters(ids: ids)
            case .increment(let id): incrementCounter(id: id)
            case .decrement(let id): decrementCounter(id: id)
        }
    }
    
    @objc func didTapAddButtonAction(_ sender: Any) {
        createCounter()
    }
    
    @objc func didTapShareButtonAction(_ sender: Any) {
        var messageToShare = String()
        innerView.getSelectedItems()?.forEach { indexPath in
            let counter = counterItems[indexPath.row]
            messageToShare.append("\n\(counter.count) x \(counter.title)")
        }
        shareCounters(message: [messageToShare])
    }
    
    @objc func didTapSelectAllButtonAction(_ sender: Any) {
        innerView.selectAllItems(in: Section.main.rawValue)
    }
    
    @objc func didTapDeleteButtonAction(_ sender: Any) {
        var selectedIds = [String]()
        innerView.getSelectedItems()?.forEach { selectedIds.append(counterItems[$0.row].id) }
        guard !selectedIds.isEmpty else { return }
        let cancelAction = UIAlertAction(title: Locale.alertButtonCancel.localized, style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: Locale.alertButtonDelete.localized(with: selectedIds.count), style: .destructive) { _ in
            self.deleteCounters(ids: selectedIds)
        }
        let deleteAlert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        deleteAlert.view.tintColor = Palette.accent.uiColor
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
}

// MARK: Delegates

extension CounterListViewController: ExceptionViewDelegate {
    
    func didTapButtonAction(tag: Int) {
        executeRetryAction()
    }
    
}

extension CounterListViewController: CounterListViewDelegate {
    
    func didPullToRefresh() {
        fetchCounters()
    }
    
}

extension CounterListViewController: CounterCellViewDelegate {
    
    func didTapCounterIncremented(id: String) {
        animateUpdate = false
        incrementCounter(id: id)
    }
    
    func didTapCounterDecremented(id: String) {
        animateUpdate = false
        decrementCounter(id: id)
    }
    
}


extension CounterListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let term = searchController.searchBar.text, !term.isEmpty, !counterItems.isEmpty else {
            applySnapshot(items: counterItems)
            innerView.hideBackgroundView()
            return
        }
    }
    
}

extension CounterListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            innerView.dimmCollectionView()
            return
        }
        animateUpdate = true
        searchCounter(term: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.isEmpty { innerView.dimmCollectionView()  }
        isSearchActive = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = .none
        isSearchActive = false
        innerView.undimmCollectionView()
        finishSearch()
    }
    
}

// MARK: Helpers

private extension CounterListViewController {
    
    func presentAlertDialog(title: String?, message: String?, _ retryAction: UIAlertAction, _ dismissAction: UIAlertAction) {
        if let currentAlert = self.presentedViewController as? UIAlertController {
            currentAlert.title = title
            currentAlert.message = message
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = Palette.accent.uiColor
        alert.addAction(retryAction)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
}
