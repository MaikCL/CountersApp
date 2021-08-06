import UIKit
import Design

extension CounterListViewController {
    
    func setupNavigationBar() {
        self.title = Locale.navigationBarTitle.localized
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = Palette.accent.uiColor
    }
    
    func setupDelegates() {
        innerView.collectionView.delegate = self
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
        innerView.collectionView.isEditing = editing
        innerView.collectionView.allowsMultipleSelectionDuringEditing = editing
        innerView.collectionView.indexPathsForVisibleItems.forEach { indexPath in
            guard let cell = innerView.collectionView.cellForItem(at: indexPath) as? CounterCellView else { return }
            UIView.animate(withDuration: 0.3) {
                cell.isEditing = editing
            }
        }
    }
    
}

extension CounterListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CounterCellView else { return }
        cell.isEditing = isEditing
    }
    
}
