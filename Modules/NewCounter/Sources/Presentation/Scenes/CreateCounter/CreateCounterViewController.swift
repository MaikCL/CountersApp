import UIKit

final class CreateCounterViewController: UIViewController {
    private(set) var viewModel: CreateCounterViewModelProtocol?
    
    private(set) var titleToSave: String = ""
    
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
        setupDelegates()
    }
    
}

extension CreateCounterViewController {
    
    @objc func saveNewCounter(_ sender: Any) {
        guard let titleToSave = innerView.titleInserted else { return }
        print("save")
    }
    
    @objc func cancelNewCounter(_ sender: Any) {
        print("cancel")
    }
    
}

extension CreateCounterViewController: CreateCounterViewDelegate {
    
    func isTitleValid(_ isValid: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isValid ? true : false
    }
    
}
