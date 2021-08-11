import UIKit
import DesignKit
import AltairMDKCommon

protocol ExamplesCounterViewDelegate: AnyObject {
    func didTapCounterExample(title: String)
}

final class ExamplesCounterView: UIView {
    var delegate: ExamplesCounterViewDelegate?
    
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
        addSubview(collectionView)
        setSubviewForAutoLayout(topMessageView)
        setSubviewForAutoLayout(topMessageLabel)
        setSubviewForAutoLayout(collectionView)
    }
    
    func setupConstraint() {
        topMessageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        NSLayoutConstraint.activate([
            topMessageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topMessageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topMessageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topMessageView.heightAnchor.constraint(equalToConstant: TopMessageViewConstants.height)
        ])
        
        NSLayoutConstraint.activate([
            topMessageLabel.centerYAnchor.constraint(equalTo: topMessageView.centerYAnchor),
            topMessageLabel.centerXAnchor.constraint(equalTo: topMessageView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topMessageView.bottomAnchor, constant: 2),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
}

private extension ExamplesCounterView {
    
    enum TopMessageViewConstants {
        static let height: CGFloat = 50.0
        static let shadow: CGFloat = 1
        static let opaccity: Float = 1
    }
    
    enum Font {
        static let topMessage = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    func setupTopMessageView() -> UIView {
        let view = UIView()
        view.backgroundColor = Palette.background.uiColor
        view.layer.masksToBounds = false
        view.layer.shadowRadius = TopMessageViewConstants.shadow
        view.layer.shadowOpacity = TopMessageViewConstants.opaccity
        view.layer.shadowColor = Palette.shadow.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: TopMessageViewConstants.shadow)
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
            static let insetTop: CGFloat = 5
            static let insetBottom: CGFloat = 5
            static let insetLeading: CGFloat = 5
            static let insetTrailing: CGFloat = 5
            static let groupSpacing: CGFloat = 5
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
        section.contentInsets = NSDirectionalEdgeInsets(top: Constants.insetTop,
                                                        leading: Constants.insetLeading,
                                                        bottom: Constants.insetBottom,
                                                        trailing: Constants.insetBottom)
        
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = Constants.groupSpacing
        section.boundarySupplementaryItems = [headerElement]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
}
