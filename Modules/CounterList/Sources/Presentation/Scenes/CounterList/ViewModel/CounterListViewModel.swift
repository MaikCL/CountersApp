import Counter
import Combine
import Resolver
import Foundation
import AltairMDKCommon

struct ViewState {
    var exception: Exception? = .none
    var isLoadingList: Bool = false
    var countersItems: [CounterModel] = []
    var searchedItems: [CounterModel] = []
    var updatingCounterId: String? = .none
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
        guard !counterStore.state.counters.isEmpty else { return }
        counterStore.trigger(.searchCounters(term: term, counters: counterStore.state.counters))
    }
    
    func finishSearch() {
        counterStore.trigger(.finishSearchCounters)
    }
}

extension CounterListViewModel {
    @Injected static var mapCounterToCounterModel: ([Counter]) -> [CounterModel]

    private func setupViewState() {
        counterStore.$state.map { state in
            let exception = state.exception
            var isLoadingList = false
            var updatingCounterId: String? = nil
            if case .whenFetchCounters = state.runningSideEffect { isLoadingList = true } else { isLoadingList = false }
            if case .whenIncrementCounter(let counter) = state.runningSideEffect { updatingCounterId = counter.id }
            if case .whenDecrementCounter(let counter) = state.runningSideEffect { updatingCounterId = counter.id }
            let countersItems = CounterListViewModel.mapCounterToCounterModel(state.counters)
            let searchedItems = CounterListViewModel.mapCounterToCounterModel(state.searchedCounters)
            return ViewState(
                exception: exception,
                isLoadingList: isLoadingList,
                countersItems: countersItems,
                searchedItems: searchedItems,
                updatingCounterId: updatingCounterId)
        }
        .assignNoRetain(to: \.viewState, on: self)
        .store(in: &cancellables)
    }
}

private extension CounterListViewModel {
    
    func findCounter(by id: String) -> Counter? {
        guard let counterFinded = counterStore.state.counters.first(where: { $0.id == id }) else { return nil}
        return counterFinded
    }
    
    func findCounters(by ids: [String]) -> [Counter] {
        var countersFinded = [Counter]()
        ids.forEach { id in counterStore.state.counters.first(where: { $0.id == id }).flatMap { countersFinded.append($0) } }
        return countersFinded
    }
    
}

