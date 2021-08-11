import UIKit
import DesignKit


typealias ExampleCellRegistration = UICollectionView.CellRegistration<ExamplesViewCell, ExampleModel.ItemModel>
typealias DataSource = UICollectionViewDiffableDataSource<ExampleModel, ExampleModel.ItemModel>
typealias Snapshot = NSDiffableDataSourceSnapshot<ExampleModel, ExampleModel.ItemModel>

extension ExamplesCounterViewController {
    
    func setupNavigationController() {
        title = Locale.navigationBarExamples.localized
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    func setupDataSource() {
        let exampleCellRegistration = ExampleCellRegistration { cell, indexPath, model in
            cell.configure(with: model)
        }
        
        dataSource = DataSource(collectionView: innerView.collectionView) { collectionView, indexPath, model in
            return collectionView.dequeueConfiguredReusableCell(using: exampleCellRegistration, for: indexPath, item: model)
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            guard let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.identifier,
                for: indexPath) as? SectionHeaderView
            view?.configure(with: section)
            return view
        }
    }
    
    func setupSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(examples)
        examples.forEach { snapshot.appendItems($0.items, toSection: $0) }
        dataSource?.apply(snapshot)
    }
    
}

