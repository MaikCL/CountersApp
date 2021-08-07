import UIKit
import Design

protocol CounterListViewDelegate: AnyObject {
    func didRefreshCounterList()
    func didTapAddCounterButton()
    func didTapShareCounterButton(selectedItems: [IndexPath])
    func didTapDeleteCounterButton(selectedItems: [IndexPath])
}

final class CounterListView: UIView {
    
    lazy var collectionView: UICollectionView = {
        setupCollectionView()
    }()
    
    lazy var bottomToolbar: UIToolbar = {
       setupBottonToolbar()
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        setupRefreshControl()
    }()
    
    lazy var addCounterButtonItem: UIBarButtonItem = {
        setupAddButtonItem()
    }()
    
    lazy var shareCounterButtonItem: UIBarButtonItem = {
       setupShareButtonItem()
    }()
    
    lazy var deleteCounterButtonItem: UIBarButtonItem = {
       setupDeleteButtonItem()
    }()
    
    lazy var selectAllCounterButtonItem: UIBarButtonItem = {
        setupSelectAllButtonItem()
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
        addSubview(bottomToolbar)
        collectionView.addSubview(refreshControl)
        setSubviewForAutoLayout(collectionView)
        setSubviewForAutoLayout(bottomToolbar)
    }
    
    func setupConstraint() {
        // MARK: Toolbar Constraints
        NSLayoutConstraint.activate([
            bottomToolbar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomToolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomToolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomToolbar.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        
        // MARK: CollectionView Constraint
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomToolbar.bottomAnchor, constant: -44),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
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
    
    @objc func addButtonAction(_ sender: Any) {
        delegate?.didTapAddCounterButton()
    }
    
    @objc func shareButtonAction(_ sender: Any) {
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        delegate?.didTapShareCounterButton(selectedItems: selectedItems)
    }
    
    @objc func deleteButtonAction(_ sender: Any) {
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        delegate?.didTapDeleteCounterButton(selectedItems: selectedItems)
    }
    
    @objc func selectAllButtonAction(_ sender: Any) {
        for row in 0..<collectionView.numberOfItems(inSection: Section.main.rawValue) {
            collectionView.selectItem(at: IndexPath(row: row, section: Section.main.rawValue), animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
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
    
    func setupBottonToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: .zero)
        toolbar.tintColor = Palette.accent.uiColor
        toolbar.barTintColor = Palette.main.uiColor
        return toolbar
    }
    
    func setupRefreshControl() -> UIRefreshControl {
        let control = UIRefreshControl(frame: .zero)
        control.addTarget(self, action: #selector(refreshCounterList(_:)), for: .valueChanged)
        return control
    }
    
    func setupAddButtonItem() -> UIBarButtonItem {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction(_:)))
        buttonItem.tintColor = Palette.accent.uiColor
        return buttonItem
    }
    
    func setupDeleteButtonItem() -> UIBarButtonItem {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonAction(_:)))
        buttonItem.tintColor = Palette.accent.uiColor
        return buttonItem
    }
    
    func setupShareButtonItem() -> UIBarButtonItem {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonAction(_:)))
        buttonItem.tintColor = Palette.accent.uiColor
        return buttonItem
    }
    
    func setupSelectAllButtonItem() -> UIBarButtonItem {
        let buttonItem = UIBarButtonItem(title: Locale.barButtonItemSelectAll.localized, style: .plain, target: self, action: #selector(selectAllButtonAction(_:)))
        buttonItem.tintColor = Palette.accent.uiColor
        return buttonItem
    }
    
}
