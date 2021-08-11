import UIKit
import Combine
import AltairMDKCommon

final class ExamplesCounterViewController: UIViewController {
    private(set) var viewModel: ExamplesCounterViewModelProtocol?
    private(set) lazy var innerView = ExamplesCounterView()
    
    var dataSource: DataSource? = nil
    
    var examples: [ExampleModel] = [] {
        didSet {
            setupSnapshot()
        }
    }
    
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
        setupDataSource()
        examples = setupExampleData()
    }

}

// MARK: Main ViewController Operations

extension ExamplesCounterViewController {
    
    func saveCounter(title: String) {
        viewModel?.createExampleCounter(title: title)
        viewModel?.coordinator?.dismissExampleCounterScreen()
    }
    
}
