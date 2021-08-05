import UIKit
import Design

final class CounterListView: UIView {
    
    lazy var collectionView: UICollectionView = {
        setupCollectionView()
    }()
    
    lazy var bottomToolbar: UIToolbar = {
       setupBottonToolbar()
    }()
    
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
        addSubview(collectionView)
        addSubview(bottomToolbar)
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
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor), // TODO: CAMBIAR POR EL SEARCHBAR DE AHI
            collectionView.bottomAnchor.constraint(equalTo: bottomToolbar.bottomAnchor), // TODO: ?????
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
}

private extension CounterListView {
    
    func setupCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CollectionViewLayout.layout)
        collectionView.backgroundColor = Palette.background.uiColor
        collectionView.alwaysBounceVertical = true
        return collectionView
    }
    
    func setupBottonToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.tintColor = Palette.accent.uiColor
        toolbar.barTintColor = Palette.main.uiColor
        return toolbar
    }
    
}
