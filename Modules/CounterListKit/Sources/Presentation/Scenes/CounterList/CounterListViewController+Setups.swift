import UIKit
import DesignKit

extension CounterListViewController {
    
    func setupNavigationController() {
        self.title = Locale.navigationBarTitle.localized
        editButtonItem.isEnabled = false
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = editButtonItem
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = Palette.accent.uiColor
        toolbarItems = setupToolbar()
    }
    
    func setupDelegates() {
        innerView.delegate = self
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.searchBar.delegate = self
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: .none)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = Locale.searchBarPlaceholder.localized
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).clearButtonMode = .never
        navigationItem.searchController = searchController
    }
    
    func setupSelectAllCounterButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(title: Locale.buttonItemSelectAll.localized, style: .plain, target: self, action: #selector(didTapSelectAllButtonAction(_:)))
    }
    
    func setupToolbarEditMode() -> [UIBarButtonItem] {
        let deleteButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDeleteButtonAction(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let actionButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButtonAction(_:)))
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
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButtonAction(_:)))
        let counterResumeItem = UIBarButtonItem(customView: counterResumeLabel)
        counterResumeItem.tag = 1

        return [flexibleSpace, counterResumeItem, flexibleSpace, addButtonItem]
    }

}
