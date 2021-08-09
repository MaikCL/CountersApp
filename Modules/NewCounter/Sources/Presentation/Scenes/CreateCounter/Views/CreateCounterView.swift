import UIKit
import Design

final class CreateCounterView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CreateCounterView {
    
    func setupView() {
        backgroundColor = Palette.background.uiColor
    }
    
}
