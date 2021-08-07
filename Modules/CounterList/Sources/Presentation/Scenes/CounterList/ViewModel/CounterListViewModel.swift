import Combine
import Resolver
import Foundation
import AltairMDKCommon

struct ViewState {
    var counters: Loadable<[CounterModel]> = .neverLoaded
    var exception: CounterException? = .none
    var titleException: String? = .none
    var searchedCounters: [CounterModel] = []
}

protocol CounterListViewModelProtocol {
    var coordinator: CounterListFlow? { get set }
    var statePublisher: Published<ViewState>.Publisher { get }
    
    func fetchCounters()
    func deleteCounter(id: String)
    func incrementCounter(id: String)
    func decrementCounter(id: String)
    func searchCounter(term: String)
    func finishSearch()
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
    
    func deleteCounter(id: String) {
        guard let counter = findCounter(by: id) else { return }
        counterListStore.trigger(.deleteCounter(counter))
    }
    
    func incrementCounter(id: String) {
        guard let counter = findCounter(by: id) else { return }
        counterListStore.trigger(.incrementCounter(counter))
    }
    
    func decrementCounter(id: String) {
        guard let counter = findCounter(by: id) else { return }
        counterListStore.trigger(.decrementCounter(counter))
    }
    
    func searchCounter(term: String) {
        guard case let .loaded(counters) = counterListStore.state.counters else { return }
        counterListStore.trigger(.searchCounters(term: term, counters: counters))
    }
    
    func finishSearch() {
        counterListStore.trigger(.finishSearchCounters)
    }
}

extension CounterListViewModel {
    @Injected static var mapCounterToCounterModel: ([Counter]) -> [CounterModel]
    
    private func findCounter(by id: String) -> Counter? {
        guard
            case let .loaded(counters) = counterListStore.state.counters,
            let counter = counters.first(where: { $0.id == id })
        else { return nil }
        return counter
    }
    
    private func setupViewState() {
        counterListStore.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
            guard let self = self else { return }
            let counters = state.counters.map { CounterListViewModel.mapCounterToCounterModel($0) }
            let exception = state.exception
            let titleException = state.titleException
            let searchedCounters = CounterListViewModel.mapCounterToCounterModel(state.searchedCounters)
            self.viewState = ViewState(
                counters: counters,
                exception: exception,
                titleException: titleException,
                searchedCounters: searchedCounters)
        }
        .store(in: &cancellables)
    }
}
