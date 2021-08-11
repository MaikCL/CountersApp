import UIKit
import DesignKit
import AltairMDKCommon

protocol CreateCounterViewDelegate: AnyObject {
    func isTitleValid(_ isValid: Bool)
    func didTapSeeExamplesLabel()
}

final class CreateCounterView: UIView {
    var delegate: CreateCounterViewDelegate?

    lazy private var activityIndicator: UIActivityIndicatorView = {
        setupActivityIndicator()
    }()
    
    lazy private var titleTextField: UITextField = {
        setupTitleTextField()
    }()
    
    lazy private var seeExamplesLabel: UILabel = {
        setupSeeExamplesLabel()
    }()
    
    var titleInserted: String? {
        guard let textFieldText = titleTextField.text as NSString? else { return nil }
        return textFieldText.trimmingCharacters(in: .whitespaces)
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupSubviews()
        setupConstraint()
        setupSeeExamplesLabelGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
}

private extension CreateCounterView {
    
    func setupView() {
        backgroundColor = Palette.background.uiColor
    }
    
    func setupSubviews() {
        addSubview(titleTextField)
        addSubview(seeExamplesLabel)
        addSubview(activityIndicator)
        setSubviewForAutoLayout(titleTextField)
        setSubviewForAutoLayout(seeExamplesLabel)
        setSubviewForAutoLayout(activityIndicator)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: TitleTextFieldConstant.top),
            titleTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: TitleTextFieldConstant.leading),
            titleTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -TitleTextFieldConstant.trailing),
            titleTextField.heightAnchor.constraint(equalToConstant: TitleTextFieldConstant.height)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: titleTextField.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor, constant: -ActivityIndicatorConstant.leading)
        ])
        
        NSLayoutConstraint.activate([
            seeExamplesLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: SeeExamplesLabelConstant.top),
            seeExamplesLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: SeeExamplesLabelConstant.leading),
            seeExamplesLabel.heightAnchor.constraint(equalToConstant: SeeExamplesLabelConstant.height)
        ])
    }
    
    func setupSeeExamplesLabelGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSeeExampleAttributedTextAction(_:)))
        tap.buttonMaskRequired = .primary
        seeExamplesLabel.addGestureRecognizer(tap)
        seeExamplesLabel.isUserInteractionEnabled = true
    }
    
}

private extension CreateCounterView {
    
    @objc func didTapSeeExampleAttributedTextAction(_ sender: UITapGestureRecognizer) {
        guard let range = seeExamplesLabel.text?.range(of: Locale.labelTextSeeExamples.localized)?.nsRange else { return }
        if sender.didTapAttributedTextInLabel(label: seeExamplesLabel, inRange: range) {
            delegate?.didTapSeeExamplesLabel()
        }

    }
    
}

private extension CreateCounterView {
    
    enum TitleTextFieldConstant {
        static let leading: CGFloat = 12.0
        static let trailing: CGFloat = 12.0
        static let top: CGFloat = 25.0
        static let height: CGFloat = 55.0
        static let cornerRadius: CGFloat = 8.0
        static let paddingLeft: CGRect = CGRect(x: 0, y: 0, width: 17, height: 50)
        static let paddingRight: CGRect = CGRect(x: 0, y: 0, width: 40, height: 50)
    }
    
    enum SeeExamplesLabelConstant {
        static let top: CGFloat = 0.0
        static let leading: CGFloat = 24.0
        static let trailing: CGFloat = 24.0
        static let height: CGFloat = 46.0
    }
    
    enum ActivityIndicatorConstant {
        static let leading: CGFloat = 12.0
    }
    
    enum Font {
        static let hint = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let text = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let example = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    func setupTitleTextField() -> UITextField {
        let textField = UITextField()
        textField.setupKeyboard(.normal, returnKeyType: .continue)
        textField.placeholder = Locale.textFieldHintExampleTitle.localized
        textField.textColor = Palette.primaryText.uiColor
        textField.set(cornerRadius: TitleTextFieldConstant.cornerRadius)
        textField.layer.masksToBounds = true
        textField.layer.backgroundColor = Palette.textfield.uiColor.cgColor
        textField.leftView = UIView(frame: TitleTextFieldConstant.paddingLeft)
        textField.rightView = UIView(frame: TitleTextFieldConstant.paddingRight)
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.clearButtonMode = .never
        textField.delegate = self
        return textField
    }
    
    func setupActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.bringSubviewToFront(self)
        return activityIndicator
    }
    
    func setupSeeExamplesLabel() -> UILabel {
        let label = UILabel()
        let textNormal = Locale.labelTextGiveACreativeName.localized
        let textUnderlined = Locale.labelTextSeeExamples.localized
        let attributedTextNormal = NSAttributedString(string: textNormal)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let attributedTextUnderlined = NSAttributedString(string: textUnderlined, attributes: underlineAttribute)
        let result = NSMutableAttributedString()
        result.append(attributedTextNormal)
        result.append(attributedTextUnderlined)
        label.attributedText = result
        label.numberOfLines = 1
        label.font = Font.example
        label.textColor = Palette.secondaryText.uiColor
        return label
    }
    
}

extension CreateCounterView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text as NSString? else { return false }
        let text = textFieldText.replacingCharacters(in: range, with: string).trimmingCharacters(in: .whitespaces)
        if !text.isEmpty  {
            delegate?.isTitleValid(true)
        } else {
            delegate?.isTitleValid(false)
        }
        return true
    }

}
