import UIKit
import Design
import AltairMDKCommon

final class CounterCellView: UICollectionViewListCell {
    
    lazy var cellView: UIView = {
       setupCellView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubviews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CounterCellView {
    
    func setupView() {
        backgroundColor = Palette.background.uiColor
    }
    
    func setupSubviews() {
        addSubview(cellView)
        setSubviewForAutoLayout(cellView)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension CounterCellView {
    
    func setupCellView() -> UIView {
        let view = UIView()
        view.backgroundColor = Palette.cellBackground.uiColor
        return view
    }
    
}
