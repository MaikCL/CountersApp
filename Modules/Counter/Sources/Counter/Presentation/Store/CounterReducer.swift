import Foundation

final class CounterReducer {
    
    static func reduce(_ state: CounterState, _ action: CounterAction) -> CounterState {
        let semaphore = DispatchSemaphore(value: 0)
        var currentState = state
        switch action {
            case .fetchCounters:
                currentState.counters = []
                currentState.exception = .none
                currentState.runningSideEffect = .whenFetchCounters
                semaphore.signal()
                
            case .fetchCountersSuccess(let results):
                currentState.counters = results
                currentState.exception = .none
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .fetchCountersFailed(let exception):
                currentState.counters = []
                currentState.exception = exception
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .createCounter(let title):
                currentState.counters = []
                currentState.exception = .none
                currentState.runningSideEffect = .whenCreateCounter(title: title)
                
            case .createCounterSuccess(let results):
                currentState.counters = results
                currentState.exception = .none
                currentState.runningSideEffect = .none
                
            case .createCounterFailed(let exception):
                currentState.counters = []
                currentState.exception = exception
                currentState.runningSideEffect = .none
                
            case .incrementCounter(let counter):
                currentState.runningSideEffect = .whenIncrementCounter(counter)
                semaphore.signal()
                
            case .incrementCounterSuccess(let results):
                currentState.counters = results
                currentState.exception = .none
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .incrementCounterFailed(let exception):
                currentState.exception = exception
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .decrementCounter(let counter):
                currentState.runningSideEffect = .whenDecrementCounter(counter)
                semaphore.signal()
                
            case .decrementCounterSuccess(let results):
                currentState.counters = results
                currentState.exception = .none
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .decrementCounterFailed(let exception):
                currentState.exception = exception
                currentState.runningSideEffect = .none
                semaphore.signal()
            
            case .deleteCounters(let counters):
                currentState.exception = .none
                currentState.runningSideEffect = .whenDeleteCounters(counters)
                semaphore.signal()
                
            case .deleteCountersCompleted(let results, let exception):
                if let results = results { currentState.counters = results }
                currentState.exception = exception
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .searchCounters(let term, let counters):
                currentState.exception = .none
                currentState.searchedCounters = []
                currentState.runningSideEffect = .whenSearchCounters(term: term, counters: counters)
                semaphore.signal()
                
            case .searchCountersSuccess(let results):
                currentState.exception = .none
                currentState.searchedCounters = results
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .searchCountersFailed(let exception):
                currentState.exception = exception
                currentState.searchedCounters = []
                currentState.runningSideEffect = .none
                semaphore.signal()
                
            case .finishSearchCounters:
                currentState.exception = .none
                currentState.searchedCounters = []
                currentState.runningSideEffect = .none
                semaphore.signal()
                
        }
        semaphore.wait()
        return currentState
    }
    
}
