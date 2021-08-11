import UIKit
import DesignKit
import AltairMDKCommon

protocol CounterCellViewDelegate: AnyObject {
    func didTapCounterIncremented(id: String)
    func didTapCounterDecremented(id: String)
}

class CounterCellView: UICollectionViewListCell {
    weak var delegate: CounterCellViewDelegate?
    
    private var countValue: Int?
    private var counterId: String?
    private var isUpdating = false
    private var cellViewLeadingConstraint = NSLayoutConstraint()

    lazy private var cellView: UIView = {
       setupCellView()
    }()
    
    lazy private var separatorView: UIView = {
        setupSeparatorView()
    }()
    
    lazy private var counterLabel: UILabel = {
        setupCounterLabel()
    }()
    
    lazy private var titleLabel: UILabel = {
        setupTitleLabel()
    }()
    
    lazy private var counterStepper: UIStepper = {
       setupCounterStepper()
    }()
    
    var isEditing: Bool = false {
        didSet {
            cellViewLeadingConstraint.constant = isEditing ? CellConstant.leadingEditing : CellConstant.leadingNormal
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
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
    
    func setUpdateFinish() {
        guard let countValue = countValue else { return }
        isUpdating = false
        counterStepper.value = Double(countValue)
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
            separatorView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: SeparatorConstant.leading),
            separatorView.widthAnchor.constraint(equalToConstant: SeparatorConstant.width)
        ])
        
        NSLayoutConstraint.activate([
            counterLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: CounterConstant.top),
            counterLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: CounterConstant.leading),
            counterLabel.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: -CounterConstant.trailing)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: TitleConstant.top),
            titleLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: TitleConstant.leading),
            titleLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -TitleConstant.trailing),
        ])
        
        NSLayoutConstraint.activate([
            counterStepper.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: StepperConstant.top),
            counterStepper.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -StepperConstant.bottom),
            counterStepper.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -StepperConstant.trailing),
            counterStepper.heightAnchor.constraint(equalToConstant: StepperConstant.height)
        ])
        
    }
}

private extension CounterCellView {
    
    enum CellConstant {
        static let leadingNormal: CGFloat = 0.0
        static let leadingEditing: CGFloat = 18.0
    }
    
    enum SeparatorConstant {
        static let leading: CGFloat = 59.0
        static let width: CGFloat = 2.0
    }
    
    enum CounterConstant {
        static let top: CGFloat = 15.0
        static let leading: CGFloat = 10.0
        static let trailing: CGFloat = 10.0
    }
    
    enum TitleConstant {
        static let top: CGFloat = 16.0
        static let leading: CGFloat = 10.0
        static let trailing: CGFloat = 14.0
    }
    
    enum StepperConstant {
        static let top: CGFloat = 17.0
        static let bottom: CGFloat = 14.0
        static let trailing: CGFloat = 14.0
        static let height: CGFloat = 29.0
    }
    
    
    enum Constants {
        static let radius: CGFloat = 8.0
    }
    
    enum Font {
        static let counter = UIFont.systemFont(ofSize: 24.0, weight: .medium)
        static let title = UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }
    
    func setupCellView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = Palette.cellBackground.uiColor
        view.set(cornerRadius: Constants.radius)
        return view
    }
    
    func setupSeparatorView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = Palette.background.uiColor
        return view
    }
    
    func setupCounterLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        let font: UIFont
        if let descriptor = Font.counter.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: 24)
        } else {
            font = Font.counter
        }
        label.font = font
        label.textAlignment = .right
        label.textColor = Palette.accent.uiColor
        return label
    }
    
    func setupTitleLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = Font.title
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

