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
        setSubviewForAutoLayout(topMessageView)
        setSubviewForAutoLayout(topMessageLabel)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            topMessageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topMessageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            topMessageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            topMessageView.heightAnchor.constraint(equalToConstant: TopMessageViewConstants.height)
        ])
        
        NSLayoutConstraint.activate([
            topMessageLabel.centerYAnchor.constraint(equalTo: topMessageView.centerYAnchor),
            topMessageLabel.centerXAnchor.constraint(equalTo: topMessageView.centerXAnchor),
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
    
}
