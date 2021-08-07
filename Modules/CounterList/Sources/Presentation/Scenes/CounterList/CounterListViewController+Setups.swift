import UIKit
import Design

extension CounterListViewController {
    
    func setupNavigationBar() {
        self.title = Locale.navigationBarTitle.localized
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = Palette.accent.uiColor
        extendedLayoutIncludesOpaqueBars = true
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
        navigationItem.rightBarButtonItem = editing ? innerView.selectAllCounterButtonItem : .none
    }
    
}
