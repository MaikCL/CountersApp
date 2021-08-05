import UIKit

typealias CounterCellRegistration = UICollectionView.CellRegistration<CounterCellView, CounterModel>
typealias DataSource = UICollectionViewDiffableDataSource<Section, CounterModel>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CounterModel>

enum Section: Int, CaseIterable {
    case main = 0
}

extension CounterListViewController {
    
    func configureDataSource() {
        let counterCell = CounterCellRegistration { cell, _, model in
            cell.configure(with: model)
            cell.delegate = self
            let accessories: [UICellAccessory] = [.multiselect(displayed: .whenEditing)]
            cell.accessories = accessories
        }
        
        dataSource = DataSource(collectionView: innerView.collectionView) { collectionView, indexPath, model in
            return collectionView.dequeueConfiguredReusableCell(using: counterCell, for: indexPath, item: model)
        }
        innerView.collectionView.dataSource = dataSource
    }
    
    // TODO: Improve with especific item reload
    func applySnapshot(animate: Bool = true) {
        var snapshot = dataSource?.snapshot() ?? Snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(counterItems)
        dataSource?.apply(snapshot, animatingDifferences: animate)
    }

}
