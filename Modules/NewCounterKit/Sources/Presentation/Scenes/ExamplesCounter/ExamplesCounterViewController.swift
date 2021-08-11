import UIKit
import Combine

final class ExamplesCounterViewController: UIViewController {
    private(set) var viewModel: ExamplesCounterViewModelProtocol?
    private(set) lazy var innerView = ExamplesCounterView()
    
    init(viewModel: ExamplesCounterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = innerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
    }
    
}
