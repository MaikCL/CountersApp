import Combine
import Resolver
import Foundation
import AltairMDKCommon

struct ViewState {
    var isCreated: Bool = false
    var exception: NewCounterException? = .none
}

protocol CreateCounterViewModelProtocol {
    var statePublisher: Published<ViewState>.Publisher { get }
    var coordinator: CreateCounterFlow? { get set }
    
    func createCouter(title: String)
}

final class CreateCounterViewModel: CreateCounterViewModelProtocol {
    var statePublisher: Published<ViewState>.Publisher { $viewState }
    var coordinator: CreateCounterFlow?
    
    @Injected private var newCounterStore: NewCounterStore
    @Published private var viewState = ViewState()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupViewState()
    }
    
    func createCouter(title: String) {
        newCounterStore.trigger(.createCounter(title: title))
    }
    
}

private extension CreateCounterViewModel {
    
    func setupViewState() {
        newCounterStore.$state.map { state in
            let isCreated = !state.countersCreated.isEmpty
            let exception = state.exception
            return ViewState(isCreated: isCreated, exception: exception)
        }
        .assignNoRetain(to: \.viewState, on: self)
        .store(in: &cancellables)
    }
    
}
