import UIKit
import Design
import AltairMDKCommon

protocol CounterCellViewDelegate: AnyObject {
    func didTapCounterIncremented(id: String)
    func didTapCounterDecremented(id: String)
}

class CounterCellView: UICollectionViewListCell {
    
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
    
    var isEditing: Bool = false {
        didSet {
            cellViewLeadingConstraint.constant = isEditing ? 18.0 : 0.0
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    private var countValue: Int?
    private var counterId: String?
    private var isUpdating = false
    private var cellViewLeadingConstraint = NSLayoutConstraint()
    
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
        counterLabel.textColor = countValue == 0 ?  Palette.disabledText.uiColor : Palette.accent.uiColor
        isUpdating = false
    }

}

private extension CounterCellView {
    
    @objc func stepperValueChanged(_ stepper: UIStepper) {
        guard let countValue = countValue, let counterId = counterId else { return }
        guard !isUpdating else { stepper.value = Double(countValue); return }
        
        if Int(stepper.value) > countValue {
            delegate?.didTapCounterIncremented(id: counterId)
        } else if Int(stepper.value) < countValue {
            delegate?.didTapCounterDecremented(id: counterId)
        
        }
        
        isUpdating = true
    }
    
}

private extension CounterCellView {
    
    func setupView() {
        backgroundView = UIView(frame: .zero)
        backgroundView?.backgroundColor = Palette.background.uiColor
        selectedBackgroundView = UIView(frame: .zero)
        selectedBackgroundView?.backgroundColor = Palette.background.uiColor
        contentView.backgroundColor = Palette.background.uiColor
    }
    
    func setupSubviews() {
        contentView.addSubview(cellView)
        contentView.setSubviewForAutoLayout(cellView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(counterLabel)
        cellView.addSubview(separatorView)
        cellView.addSubview(counterStepper)
        cellView.setSubviewForAutoLayout(titleLabel)
        cellView.setSubviewForAutoLayout(counterLabel)
        cellView.setSubviewForAutoLayout(separatorView)
        cellView.setSubviewForAutoLayout(counterStepper)
        
    }
    
    func setupConstraint() {
        cellViewLeadingConstraint = cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        NSLayoutConstraint.activate([
            cellViewLeadingConstraint,
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: cellView.topAnchor),
            separatorView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 59.0),
            separatorView.widthAnchor.constraint(equalToConstant: 2.0)
        ])
        
        NSLayoutConstraint.activate([
            counterLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 15.0),
            counterLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10.0),
            counterLabel.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: -10.0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -14.0),
        ])
        
        NSLayoutConstraint.activate([
            counterStepper.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 17.0),
            counterStepper.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -14.0),
            counterStepper.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -14.0),
            counterStepper.heightAnchor.constraint(equalToConstant: 29.0)
        ])
        
    }
}

private extension CounterCellView {
    
    func setupCellView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = Palette.cellBackground.uiColor
        view.set(cornerRadius: 8.0)
        return view
    }
    
    func setupSeparatorView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = Palette.background.uiColor
        return view
    }
    
    func setupCounterLabel() -> UILabel {
        let label = UILabel(frame: .zero)
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
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = Palette.primaryText.uiColor
        return label
    }
    
    func setupCounterStepper() -> UIStepper {
        let stepper = UIStepper(frame: .zero)
        stepper.autorepeat = false
        stepper.wraps = false
        stepper.minimumValue = 0
        stepper.maximumValue = 999
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        return stepper
    }
    
}

