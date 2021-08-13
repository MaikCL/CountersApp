import Combine
import Resolver
import CounterKit
import AltairMDKCommon

struct ViewState {
    var counters: Loadable<[CounterModel]> = .neverLoaded
    var exception: Exception? = .none
    var searchedCounters: [CounterModel] = []
}

protocol CounterListViewModelProtocol {
    var statePublisher: Published<ViewState>.Publisher { get }
    var coordinator: CounterListFlow? { get set }
    
    func fetchCounters()
    func deleteCounters(ids: [String])
    func incrementCounter(id: String)
    func decrementCounter(id: String)
    func searchCounter(term: String)
    func finishSearch()
    func dismissDialog()
}

final class CounterListViewModel: CounterListViewModelProtocol {
    var statePublisher: Published<ViewState>.Publisher { $viewState }
    var coordinator: CounterListFlow?

    @Injected private var counterStore: CounterStore
    @Published private var viewState = ViewState()

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupViewState()
    }
    
    func fetchCounters() {
        counterStore.trigger(.fetchCounters)
    }
    
    func deleteCounters(ids: [String]) {
        let counters = findCounters(by: ids)
        counterStore.trigger(.deleteCounters(counters))
    }
    
    func incrementCounter(id: String) {
        guard let counter = findCounter(by: id) else { return }
        counterStore.trigger(.incrementCounter(counter))
    }
    
    func decrementCounter(id: String) {
        guard let counter = findCounter(by: id) else { return }
        counterStore.trigger(.decrementCounter(counter))
    }
    
    func searchCounter(term: String) {
        guard case let .loaded(counters) = counterStore.state.counters else { return }
        counterStore.trigger(.searchCounters(term: term, counters: counters))
    }
    
    func finishSearch() {
        counterStore.trigger(.finishSearchCounters)
    }
    
    func dismissDialog() {
        counterStore.trigger(.resetException)
    }
}

extension CounterListViewModel {
    @Injected static var mapCounterToCounterModel: ([Counter]) -> [CounterModel]

    private func setupViewState() {
        counterStore.$state.map { state in
            let counters = state.counters.map { CounterListViewModel.mapCounterToCounterModel($0) }
            let exception = state.exception
            let searchedCounters = CounterListViewModel.mapCounterToCounterModel(state.searchedCounters)
            return ViewState(counters: counters, exception: exception, searchedCounters: searchedCounters)
        }
        .assignNoRetain(to: \.viewState, on: self)
        .store(in: &cancellables)
    }
}

private extension CounterListViewModel {
    
    func findCounter(by id: String) -> Counter? {
        guard case let .loaded(counters) = counterStore.state.counters else { return nil }
        guard let counterFinded = counters.first(where: { $0.id == id }) else { return nil }
        return counterFinded
    }
    
    func findCounters(by ids: [String]) -> [Counter] {
        guard case let .loaded(counters) = counterStore.state.counters else { return [] }
        var countersFinded = [Counter]()
        ids.forEach { id in counters.first { $0.id == id }.flatMap { countersFinded.append($0) } }
        return countersFinded
    }
    
}

