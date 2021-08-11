import UIKit
import DesignKit

protocol ExamplesCounterViewCellDelegate: AnyObject {
    func didTapExampleCounter(title: String)
}

final class ExampleCounterViewCell: UICollectionViewCell {
    var delegate: ExamplesCounterViewCellDelegate?
    
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

private extension ExampleCounterViewCell {
    
    private func setupView() {
        backgroundColor = Palette.cellBackground.uiColor
        set(cornerRadius: Constants.radius)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCellAction(_:)))
        addGestureRecognizer(tap)
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

private extension ExampleCounterViewCell {
    
    @objc func didTapCellAction(_ sender: UITapGestureRecognizer?) {
        delegate?.didTapExampleCounter(title: itemLabel.text ?? "")
    }
    
}

private extension ExampleCounterViewCell {
    
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
