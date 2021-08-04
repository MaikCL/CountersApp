import UIKit

final class CounterListViewController: UIViewController {
    private var viewModel: CounterListViewModelProtocol?
    
    private lazy var innerView = CounterListView()
    
    init(viewModel: CounterListViewModelProtocol) {
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
        setupNavigationBar()
    }
    
}
