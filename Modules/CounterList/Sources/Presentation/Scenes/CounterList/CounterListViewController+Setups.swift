import UIKit
import Design

extension CounterListViewController {
    
    func setupNavigationComponents() {
        self.title = Locale.navigationBarTitle.localized
        editButtonItem.isEnabled = false
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = editButtonItem
        toolbarItems = setupToolbar()
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = Palette.accent.uiColor
    }
    
    func setupDelegates() {
        innerView.delegate = self
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.searchBar.delegate = self
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: .none)
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = Locale.searchBarPlaceholder.localized
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).clearButtonMode = .never
        navigationItem.searchController = searchController
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        innerView.isEditMode = editing
        navigationItem.rightBarButtonItem = editing ? setupSelectAllCounterButtonItem() : .none
        if editing {
            toolbarItems = setupToolbarEditMode()
        } else {
            toolbarItems = setupToolbar()
            updateCounterResumeToolbar(counters: counterItems)
        }

    }
    
    func setupSelectAllCounterButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(title: Locale.barButtonItemSelectAll.localized, style: .plain, target: self, action: #selector(selectAllButtonAction(_:)))
    }
    
    func setupToolbarEditMode() -> [UIBarButtonItem] {
        let deleteButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonAction(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let actionButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonAction(_:)))
        return [deleteButtonItem, flexibleSpace, actionButtonItem]
    }
    
    func setupToolbar() -> [UIBarButtonItem] {
        let counterResumeLabel = UILabel(frame: .zero)
        counterResumeLabel.font = .systemFont(ofSize: 15, weight: .regular)
        counterResumeLabel.textColor = Palette.secondaryText.uiColor
        counterResumeLabel.backgroundColor = .clear
        counterResumeLabel.textAlignment = .natural
        counterResumeLabel.isEnabled = false
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction(_:)))
        let counterResumeItem = UIBarButtonItem(customView: counterResumeLabel)
        counterResumeItem.tag = 1

        return [flexibleSpace, counterResumeItem, flexibleSpace, addButtonItem]
    }
    
    func updateCounterResumeToolbar(counters: [CounterModel]) {
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

    func setupAlertViewForUpdateFailed(counter: Counter, exception: CounterException) {
        if let currentAlert = self.presentedViewController as? UIAlertController {
            currentAlert.title = exception.errorTitle
            currentAlert.message = exception.errorDescription
            return
        }
        
        let retryAction = UIAlertAction(title: Locale.alertButtonRetry.localized, style: .cancel) { _ in
            self.retryUpdateButtonAction()
        }
        
        let dismissAction = UIAlertAction(title: Locale.alertButtonDismiss.localized, style: .default) { _ in
            guard let counterIndex = self.counterItems.firstIndex(where: { $0.id == counter.id }) else { return }
            let counterItemRow = IndexPath(row: Int(counterIndex), section: Section.main.rawValue)
            guard let cell = self.innerView.collectionView.cellForItem(at: counterItemRow) as? CounterCellView else { return }
            cell.notUpdated()
        }
        
        let alert = UIAlertController(title: exception.errorTitle, message: exception.errorDescription, preferredStyle: .alert)
        alert.view.tintColor = Palette.accent.uiColor
        alert.addAction(dismissAction)
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
