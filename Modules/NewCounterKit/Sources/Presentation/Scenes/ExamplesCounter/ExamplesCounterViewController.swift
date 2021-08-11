import UIKit
import Combine

final class ExamplesCounterViewController: UIViewController {
    private(set) var viewModel: ExamplesCounterViewModelProtocol?
    private(set) lazy var innerView = ExamplesCounterView()
    
    var dataSource: DataSource? = nil
    
    private(set) var examples: [ExampleModel] = [] {
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
        
        examples = generateExampleData()
    }
    
}

// TODO: Can be migrated to Data Layer
private extension ExamplesCounterViewController {
    
    func generateExampleData() -> [ExampleModel] {
        return [
            ExampleModel(category: "DRINKS", items: [
                ExampleModel.ItemModel(title: "Cups on Coffe"),
                ExampleModel.ItemModel(title: "Glass of water"),
                ExampleModel.ItemModel(title: "Piscolas"),
            ]),
            ExampleModel(category: "FOOD", items: [
                ExampleModel.ItemModel(title: "Hot dog"),
                ExampleModel.ItemModel(title: "Cupcackes eaten"),
                ExampleModel.ItemModel(title: "Chiquen"),
                ExampleModel.ItemModel(title: "Pizzas"),
                ExampleModel.ItemModel(title: "Mashmellows"),
                ExampleModel.ItemModel(title: "Avocados"),
                ExampleModel.ItemModel(title: "Papitas fritas")
            ]),
            ExampleModel(category: "MISC", items: [
                ExampleModel.ItemModel(title: "Times sneezed"),
                ExampleModel.ItemModel(title: "Naps"),
                ExampleModel.ItemModel(title: "Daydreams"),
                ExampleModel.ItemModel(title: "Days Coding"),
            ])
        ]
    }
    
}
