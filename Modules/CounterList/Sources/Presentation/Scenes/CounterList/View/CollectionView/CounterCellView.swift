import UIKit
import Design
import AltairMDKCommon

protocol CounterCellViewDelegate: AnyObject {
    func didTapCounterIncremented(id: String)
    func didTapCounterDecremented(id: String)
}

final class CounterCellView: UICollectionViewListCell {
    
    lazy var cellView: UIView = {
       setupCellView()
    }()
    
    lazy var separatorView: UIView = {
        setupSeparatorView()
    }()
    
    lazy var counterLabel: UILabel = {
        setupCounterLabel()
    }()
    
    lazy var titleLabel: UILabel = {
        setupTitleLabel()
    }()
    
    lazy var counterStepper: UIStepper = {
       setupCounterStepper()
    }()
    
    private var countValue: Int?
    private var counterId: String?
    
    weak var delegate: CounterCellViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubviews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: CounterModel) {
        counterId = model.id
        titleLabel.text = model.title
        counterLabel.text = model.count
        countValue = Int(model.count)
        counterStepper.value = Double(model.count) ?? 0
        layoutIfNeeded()
    }
    
}

private extension CounterCellView {
    
    @objc func stepperValueChanged(_ stepper: UIStepper) {
        guard let countValue = countValue, let counterId = counterId else { return }
        if Int(stepper.value) > countValue {
            delegate?.didTapCounterIncremented(id: counterId)
        } else if Int(stepper.value) < countValue {
            delegate?.didTapCounterDecremented(id: counterId)
        }
    }
    
}

private extension CounterCellView {
    
    func setupView() {
        backgroundColor = Palette.background.uiColor
        set(cornerRadius: 8.0)
    }
    
    func setupSubviews() {
        addSubview(cellView)
        addSubview(titleLabel)
        addSubview(counterLabel)
        addSubview(separatorView)
        addSubview(counterStepper)
        setSubviewForAutoLayout(cellView)
        setSubviewForAutoLayout(titleLabel)
        setSubviewForAutoLayout(counterLabel)
        setSubviewForAutoLayout(separatorView)
        setSubviewForAutoLayout(counterStepper)
        counterStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 59.0),
            separatorView.widthAnchor.constraint(equalToConstant: 2.0)
        ])
        
        NSLayoutConstraint.activate([
            counterLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.0),
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            counterLabel.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: -10.0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14.0),
        ])
        
        NSLayoutConstraint.activate([
            counterStepper.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 17.0),
            counterStepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14.0),
            counterStepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14.0),
        ])
        
    }
}

private extension CounterCellView {
    
    func setupCellView() -> UIView {
        let view = UIView()
        view.backgroundColor = Palette.cellBackground.uiColor
        return view
    }
    
    func setupSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = Palette.background.uiColor
        return view
    }
    
    func setupCounterLabel() -> UILabel {
        let label = UILabel()
        let fontSize: CGFloat = 24.0
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        let font: UIFont
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            font = systemFont
        }
        label.font = font
        label.textAlignment = .right
        label.textColor = Palette.accent.uiColor
        return label
    }
    
    func setupTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = Palette.primaryText.uiColor
        return label
    }
    
    func setupCounterStepper() -> UIStepper {
        let stepper = UIStepper()
        stepper.autorepeat = false
        stepper.wraps = false
        stepper.minimumValue = 0
        stepper.maximumValue = 999
        return stepper
    }
    
}

