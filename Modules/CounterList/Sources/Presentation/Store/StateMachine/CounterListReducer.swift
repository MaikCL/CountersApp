import Foundation

final class CounterListReducer {
    
    static func reduce(_ state: CounterListState, _ action: CounterListAction) -> CounterListState {
        let semaphore = DispatchSemaphore(value: 0)
        var currentState = state
        
        switch action {
            case .fetchCounters:
                currentState.counters = .loading
                currentState.exception = .none
                currentState.titleException = .none
                currentState.runningSideEffect = .whenFetchCounters
                semaphore.signal()
                
            case .fetchCountersSuccess(let results):
                currentState.counters = .loaded(results)
                currentState.exception = .none
                currentState.titleException = .none
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .fetchCountersFailed(let exception):
                currentState.counters = .neverLoaded
                currentState.exception = exception
                currentState.titleException = Locale.exceptionCantLoadTitle.localized
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .incrementCounter(let counter):
                currentState.runningSideEffect = .whenIncrementCounter(counter)
                semaphore.signal()
                
            case .incrementCounterSuccess(let results):
                currentState.counters = .loaded(results)
                currentState.exception = .none
                currentState.titleException = .none
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .incrementCounterFailed(let exception, let counter):
                currentState.exception = exception
                currentState.titleException = Locale.exceptionCantUpdateTitle.localized(with: counter.count + 1)
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .decrementCounter(let counter):
                currentState.runningSideEffect = .whenDecrementCounter(counter)
                semaphore.signal()
                
            case .decrementCounterSuccess(let results):
                currentState.counters = .loaded(results)
                currentState.exception = .none
                currentState.titleException = .none
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .decrementCounterFailed(let exception, let counter):
                currentState.exception = exception
                currentState.titleException = Locale.exceptionCantUpdateTitle.localized(with: counter.count - 1)
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .searchCounters(let term, let counters):
                currentState.exception = .none
                currentState.titleException = .none
                currentState.searchedCounters = []
                currentState.runningSideEffect = .whenSearchCounters(term: term, counters: counters)
                semaphore.signal()
                
            case .searchCountersSuccess(let results):
                currentState.exception = .none
                currentState.titleException = .none
                currentState.searchedCounters = results
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .searchCountersFailed(let exception):
                currentState.exception = exception
                currentState.titleException = .none
                currentState.searchedCounters = []
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .finishSearchCounters:
                currentState.exception = .none
                currentState.titleException = .none
                currentState.searchedCounters = []
                currentState.runningSideEffect = .none
                semaphore.signal()
                
        }
        semaphore.wait()
        return currentState
    }
    
}
