import UIKit
import DesignKit
import AltairMDKCommon

// MARK: Delegates

extension ExamplesCounterViewController: ExamplesCounterViewCellDelegate {
    
    func didTapExampleCounter(title: String) {
        saveCounter(title: title)
    }
    
}
