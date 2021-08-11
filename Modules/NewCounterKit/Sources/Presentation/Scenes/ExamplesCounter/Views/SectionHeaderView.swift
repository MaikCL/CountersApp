import UIKit
import DesignKit
import AltairMDKCommon

final class SectionHeaderView: UICollectionReusableView {
    static var identifier: String {
        return String(describing: SectionHeaderView.self)
    }
    
    private lazy var headerLabel: UILabel = {
       setupHeaderLabel()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubviews()
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: ExampleModel) {
        headerLabel.text = data.category
    }

}

private extension SectionHeaderView {
    
    func setupView() {
        backgroundColor = Palette.background.uiColor
    }
    
    func setupSubviews() {
        addSubview(headerLabel)
        setSubviewForAutoLayout(headerLabel)
    }
    
    func setupConstraint() {
        headerLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            headerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constraints.bottom),
            headerLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }

}

extension SectionHeaderView {
    
    enum Constraints {
        static let bottom: CGFloat = 5.0
    }
    
    enum Font {
        static let header = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    func setupHeaderLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.header
        label.adjustsFontForContentSizeCategory = true
        label.textColor = Palette.secondaryText.uiColor
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }
    
}
