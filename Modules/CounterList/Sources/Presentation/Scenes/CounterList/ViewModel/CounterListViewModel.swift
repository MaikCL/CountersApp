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
    func deleteCounters(ids: [String])
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
    
    func deleteCounters(ids: [String]) {
        let counters = findCounters(by: ids)
        counterListStore.trigger(.deleteCounters(counters))
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
            let counterFinded = counters.first(where: { $0.id == id })
        else { return nil }
        return counterFinded
    }
    
    private func findCounters(by ids: [String]) -> [Counter] {
        guard case let .loaded(counters) = counterListStore.state.counters else { return [] }
        var countersFinded = [Counter]()
        ids.forEach { id in counters.first { $0.id == id }.flatMap { countersFinded.append($0) } }
        return countersFinded
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
