import UIKit

struct CollectionViewLayout {
    
    static var layout: UICollectionViewLayout {
        makeCompositionalPhoneLayout()
    }
    
}

extension CollectionViewLayout {
    
    private static func makeCompositionalPhoneLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(96.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16.0, leading: 12.0, bottom: 16.0, trailing: 12.0)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
