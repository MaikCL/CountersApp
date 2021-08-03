protocol CounterListViewModelProtocol {
    var coordinator: CounterListFlow? { get set }
}

final class CounterListViewModel: CounterListViewModelProtocol {
    var coordinator: CounterListFlow?
    
    init() {
        
    }
}
