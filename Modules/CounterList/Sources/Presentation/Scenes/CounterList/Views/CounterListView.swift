import UIKit
import Design

protocol CounterListViewDelegate: AnyObject {
    func didRefreshCounterList()
}

final class CounterListView: UIView {
    
    lazy var collectionView: UICollectionView = {
        setupCollectionView()
    }()

    lazy var refreshControl: UIRefreshControl = {
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
    
    var delegate: CounterListViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupSubviews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        // MARK: CollectionView Constraint
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

    @objc func refreshCounterList(_ sender: Any) {
        delegate?.didRefreshCounterList()
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
        control.addTarget(self, action: #selector(refreshCounterList(_:)), for: .valueChanged)
        return control
    }

}
