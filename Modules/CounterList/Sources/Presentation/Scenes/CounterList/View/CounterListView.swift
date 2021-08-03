import UIKit
import Design

final class CounterListView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CounterListView {
    
    func setupView() {
        backgroundColor = Palette.main.uiColor
    }
    
}
