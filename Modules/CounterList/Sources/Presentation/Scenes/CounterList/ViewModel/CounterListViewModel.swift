import Combine
import Resolver
import Foundation
import AltairMDKCommon

struct ViewState {
    var counters: Loadable<[CounterModel]> = .neverLoaded
    var exception: Exception? = .none
}

protocol CounterListViewModelProtocol {
    var coordinator: CounterListFlow? { get set }
    var statePublisher: Published<ViewState>.Publisher { get }
    
    func fetchCounters()
}

final class CounterListViewModel: CounterListViewModelProtocol {
    @Injected private var counterListStore: CounterListStore
    
    private var cancellables = Set<AnyCancellable>()
    @Published private var viewState = ViewState()
    
    var statePublisher: Published<ViewState>.Publisher { $viewState }
    var coordinator: CounterListFlow?
    
    init() {
        setupViewState()
    }
    
    func fetchCounters() {
        counterListStore.trigger(.fetchCounters)
    }
    
}

extension CounterListViewModel {
    @Injected static var mapCounterToCounterModel: ([Counter]) -> [CounterModel]
    
    private func setupViewState() {
        counterListStore.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
            guard let self = self else { return }
            let counters = state.counters.map { CounterListViewModel.mapCounterToCounterModel($0) }
            let exception = state.exception
            self.viewState = ViewState(counters: counters, exception: exception)
        }
        .store(in: &cancellables)
    }
}
