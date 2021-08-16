import Combine
import Resolver
import CounterKit
import AltairMDKCommon

struct ExamplesCounterViewState {
    var exception: Exception? = .none
    var isCreated: Bool = false
}

protocol ExamplesCounterViewModelProtocol {
    var statePublisher: Published<ExamplesCounterViewState>.Publisher { get }
    var coordinator: ExamplesCounterFlow? { get set }
    
    func createExampleCounter(title: String)
    func dismissDialog()
}

final class ExamplesCounterViewModel: ExamplesCounterViewModelProtocol {
    var statePublisher: Published<ExamplesCounterViewState>.Publisher { $viewState }
    var coordinator: ExamplesCounterFlow?
    
    @Injected private var counterStore: CounterStore
    @Published private var viewState = ExamplesCounterViewState()
    
    private var cancellables = Set<AnyCancellable>()
        
    init() {
        setupViewState()
    }
    
    func createExampleCounter(title: String) {
        counterStore.trigger(.createCounter(title: title))
    }
    
    func dismissDialog() {
        counterStore.trigger(.resetException)
    }

}

extension ExamplesCounterViewModel {

    private func setupViewState() {
        counterStore.$state.map { state in
            var isCreated = false
            if case .loaded(let results) = state.counters, !results.isEmpty { isCreated = true }
            let exception = state.exception
            return ExamplesCounterViewState(exception: exception, isCreated: isCreated)
        }
        .assignNoRetain(to: \.viewState, on: self)
        .store(in: &cancellables)
    }
}
