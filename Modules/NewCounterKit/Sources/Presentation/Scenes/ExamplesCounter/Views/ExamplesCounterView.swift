import UIKit
import DesignKit
import AltairMDKCommon

protocol ExamplesCounterViewDelegate: AnyObject {
    func didTapCounterExample(title: String)
}

final class ExamplesCounterView: UIView {
    var delegate: ExamplesCounterViewDelegate?
    
    private lazy var separatorView: UIView = {
        setupSeparatorView()
    }()
    
    private lazy var topMessageView: UIView = {
        setupTopMessageView()
    }()
    
    private lazy var topMessageLabel: UILabel = {
       setupTopMessageLabel()
    }()
    
    lazy var collectionView: UICollectionView = {
       setupCollectionView()
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setSubViews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ExamplesCounterView {
    
    func setupView() {
        backgroundColor = Palette.background.uiColor
    }
    
    func setSubViews() {
        addSubview(topMessageView)
        addSubview(topMessageLabel)
        addSubview(separatorView)
        addSubview(collectionView)
        setSubviewForAutoLayout(topMessageView)
        setSubviewForAutoLayout(topMessageLabel)
        setSubviewForAutoLayout(separatorView)
        setSubviewForAutoLayout(collectionView)
    }
    
    func setupConstraint() {
        let topMessageViewHeightConstraint = topMessageView.heightAnchor.constraint(equalToConstant: TopMessageViewConstants.height)
        let separatorViewHeightConstraint = separatorView.heightAnchor.constraint(equalToConstant: ViewSeparatorConstants.height)
        topMessageViewHeightConstraint.priority = .defaultHigh
        separatorViewHeightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            topMessageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topMessageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topMessageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topMessageViewHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            topMessageLabel.centerYAnchor.constraint(equalTo: topMessageView.centerYAnchor),
            topMessageLabel.centerXAnchor.constraint(equalTo: topMessageView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topMessageView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorViewHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
}

private extension ExamplesCounterView {
    
    enum TopMessageViewConstants {
        static let height: CGFloat = 50.0
    }
    
    enum ViewSeparatorConstants {
        static let height: CGFloat = 1.0
    }
    
    enum Font {
        static let topMessage = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    func setupTopMessageView() -> UIView {
        let view = UIView()
        view.backgroundColor = Palette.background.uiColor
        return view
    }
    
    func setupSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = Palette.shadow.uiColor
        return view
    }
    
    func setupTopMessageLabel() -> UILabel {
        let label = UILabel()
        label.text = Locale.labelTextSelectExampleToAdd.localized
        label.textColor = Palette.secondaryText.uiColor
        label.font = Font.topMessage
        return label
    }
    
    func setupCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.backgroundColor = Palette.background.uiColor
        collectionView.alwaysBounceVertical = false
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.identifier)
        return collectionView
    }
    
}

private extension ExamplesCounterView {
    
    func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        enum Constants {
            static let headerWidth: CGFloat = 1.0
            static let headerHeight: CGFloat = 60
            static let height: CGFloat = 55
            static let width: CGFloat = 150
            static let groupSpacing: CGFloat = 0
            static let edgeSpacing: CGFloat = 16
        }
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.headerWidth), heightDimension: .estimated(Constants.headerHeight))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        headerElement.extendsBoundary = true
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(Constants.width), heightDimension: .absolute(Constants.height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(Constants.edgeSpacing),
                                                         top: .none,
                                                         trailing: .fixed(Constants.edgeSpacing),
                                                         bottom: .none)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(Constants.width), heightDimension: .absolute(Constants.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = Constants.groupSpacing
        section.boundarySupplementaryItems = [headerElement]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
