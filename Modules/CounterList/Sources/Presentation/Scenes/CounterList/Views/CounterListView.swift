import UIKit
import Design
import Foundation

protocol CounterListViewDelegate: AnyObject {
    func didPullToRefresh()
}

final class CounterListView: UIView {
    var delegate: CounterListViewDelegate?

    lazy var collectionView: UICollectionView = {
        setupCollectionView()
    }()

    lazy private var refreshControl: UIRefreshControl = {
        setupRefreshControl()
    }()
    
    var isEditMode: Bool = false {
        didSet {
            collectionView.isEditing = isEditMode
            collectionView.allowsMultipleSelectionDuringEditing = isEditMode
            collectionView.indexPathsForVisibleItems.forEach { indexPath in
                guard let cell = collectionView.cellForItem(at: indexPath) as? CounterCellView else { return }
                UIView.animate(withDuration: 0.3) {
                    cell.isEditing = self.isEditMode
                }
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupSubviews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource<Section: Hashable, Model: Hashable>(dataSource: UICollectionViewDiffableDataSource<Section, Model>?) {
        collectionView.dataSource = dataSource
    }
    
    func showBackgroundView(_ view: UIView) {
        collectionView.backgroundView = view
        collectionView.isScrollEnabled = false
    }
    
    func hideExceptionView() {
        collectionView.backgroundView = nil
        collectionView.isScrollEnabled = true
    }
    
    func showListLoading() {
        collectionView.backgroundView = LoadingView()
        collectionView.isScrollEnabled = false
    }
    
    func hideListLoading() {
        collectionView.backgroundView = nil
        collectionView.isScrollEnabled = true
    }
    
    func getCell(at indexPath: IndexPath) -> CounterCellView? {
        collectionView.cellForItem(at: indexPath) as? CounterCellView
    }
    
    func getSelectedItems() -> [IndexPath]? {
        return collectionView.indexPathsForSelectedItems
    }
    
    func selectAllItems(in section: Int) {
        for row in 0..<collectionView.numberOfItems(inSection: section) {
            collectionView.selectItem(at: IndexPath(row: row, section: section), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func hideBackgroundView() {
        collectionView.backgroundView = .none
    }
    
}

private extension CounterListView {
    
    func setupView() {
        backgroundColor = Palette.background.uiColor
    }
    
    func setupSubviews() {
        addSubview(UIView(frame: .zero))
        addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        setSubviewForAutoLayout(collectionView)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }

}

extension CounterListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CounterCellView else { return }
        cell.isEditing = isEditMode
    }
    
}

private extension CounterListView {

    @objc func didPullToRefreshAction(_ sender: Any) {
        delegate?.didPullToRefresh()
    }

}

private extension CounterListView {
    
    func setupCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CollectionViewLayout.layout)
        collectionView.backgroundColor = Palette.background.uiColor
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        return collectionView
    }
    
    func setupRefreshControl() -> UIRefreshControl {
        let control = UIRefreshControl(frame: .zero)
        control.addTarget(self, action: #selector(didPullToRefreshAction(_:)), for: .valueChanged)
        return control
    }

}
