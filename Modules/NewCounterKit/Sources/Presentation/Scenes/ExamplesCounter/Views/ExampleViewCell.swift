import UIKit
import DesignKit
import AltairMDKCommon

final class ExamplesViewCell: UICollectionViewCell {
    
    private lazy var itemLabel: UILabel = {
       setupItemLabel()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: ExampleModel.ItemModel) {
        itemLabel.text = data.title
        itemLabel.sizeToFit()
        setupConstraints()
    }
    
}

private extension ExamplesViewCell {
    
    private func setupView() {
        backgroundColor = Palette.cellBackground.uiColor
        set(cornerRadius: Constants.radius)
    }
    
    private func setupSubViews() {
        addSubview(itemLabel)
        setSubviewForAutoLayout(itemLabel)
    }
    
    private func setupConstraints() {
        itemLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let itemLabelWidthConstraint = widthAnchor.constraint(equalToConstant: itemLabel.intrinsicContentSize.width + Constants.extraWidth)
        itemLabelWidthConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            itemLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            itemLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            itemLabel.heightAnchor.constraint(equalToConstant: 55),
            itemLabelWidthConstraint,
        ])
    }
    
}

private extension ExamplesViewCell {
    
    enum Constants {
        static let radius: CGFloat = 8.0
        static let extraWidth: CGFloat = 40.0
    }
    
    enum Font {
        static let item = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    
    func setupItemLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.item
        label.textColor = Palette.primaryText.uiColor
        return label
    }
    
    
}
