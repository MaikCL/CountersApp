import UIKit
import DesignKit


typealias ExampleCellRegistration = UICollectionView.CellRegistration<ExampleCounterViewCell, ExampleModel.ItemModel>
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
            cell.delegate = self
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
    
    // TODO: Can be migrated to Data Layer
    func setupExampleData() -> [ExampleModel] {
        return [
            ExampleModel(category: "DRINKS", items: [
                ExampleModel.ItemModel(title: "Cups on Coffe"),
                ExampleModel.ItemModel(title: "Glass of water"),
                ExampleModel.ItemModel(title: "Piscolas"),
            ]),
            ExampleModel(category: "FOOD", items: [
                ExampleModel.ItemModel(title: "Hot dog"),
                ExampleModel.ItemModel(title: "Cupcackes eaten"),
                ExampleModel.ItemModel(title: "Chiquen"),
                ExampleModel.ItemModel(title: "Pizzas"),
                ExampleModel.ItemModel(title: "Mashmellows"),
                ExampleModel.ItemModel(title: "Avocados"),
                ExampleModel.ItemModel(title: "Papitas fritas")
            ]),
            ExampleModel(category: "MISC", items: [
                ExampleModel.ItemModel(title: "Times sneezed"),
                ExampleModel.ItemModel(title: "Naps"),
                ExampleModel.ItemModel(title: "Daydreams"),
                ExampleModel.ItemModel(title: "Days Coding"),
            ])
        ]
    }

}

