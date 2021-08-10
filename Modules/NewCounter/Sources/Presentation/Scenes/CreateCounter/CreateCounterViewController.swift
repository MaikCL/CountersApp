import UIKit

final class CreateCounterViewController: UIViewController {
    private var viewModel: CreateCounterViewModelProtocol?
    
    lazy var innerView = CreateCounterView()
    
    init(viewModel: CreateCounterViewModelProtocol) {
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
