import Resolver
import CounterKit

protocol ExamplesCounterViewModelProtocol {
    var coordinator: ExamplesCounterFlow? { get set }
    
    func createExampleCounter(title: String)
}

final class ExamplesCounterViewModel: ExamplesCounterViewModelProtocol {
    var coordinator: ExamplesCounterFlow?
    
    @Injected private var counterStore: CounterStore
        
    init() { }
    
    func createExampleCounter(title: String) {
        counterStore.trigger(.createCounter(title: title))
    }

}
