import UIKit
import DesignKit
import AltairMDKCommon

protocol ExamplesCounterViewDelegate: AnyObject {
    func didTapCounterExample(title: String)
}

final class ExamplesCounterView: UIView {
    var delegate: ExamplesCounterViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ExamplesCounterView {
    
    func setupView() {
        backgroundColor = Palette.background.uiColor
    }
    
}
