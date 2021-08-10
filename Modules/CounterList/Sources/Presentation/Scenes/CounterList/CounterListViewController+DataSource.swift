import UIKit
import Design

typealias CounterCellRegistration = UICollectionView.CellRegistration<CounterCellView, CounterModel>
typealias DataSource = UICollectionViewDiffableDataSource<Section, CounterModel>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CounterModel>

enum Section: Int, CaseIterable {
    case main = 0
}

extension CounterListViewController {
    
    func configureDataSource() {
        let accessoryOptions = UICellAccessory.MultiselectOptions(
            isHidden: false,
            reservedLayoutWidth: .custom(16.0),
            tintColor: .none,
            backgroundColor: .none)
        
        let counterCell = CounterCellRegistration { cell, _, model in
            cell.configure(with: model)
            cell.delegate = self
            let accessories: [UICellAccessory] = [.multiselect(displayed: .whenEditing, options: accessoryOptions)]
            cell.accessories = accessories
        }
        
        dataSource = DataSource(collectionView: innerView.collectionView) { collectionView, indexPath, model in
            return collectionView.dequeueConfiguredReusableCell(using: counterCell, for: indexPath, item: model)
        }
        innerView.setDataSource(dataSource: dataSource)
    }
    
    func applySnapshot(items: [CounterModel], animate: Bool = true) {
        var snapshot = dataSource?.snapshot() ?? Snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items)
        animate ? dataSource?.apply(snapshot) : UIView.performWithoutAnimation { dataSource?.apply(snapshot) }
    }

}
