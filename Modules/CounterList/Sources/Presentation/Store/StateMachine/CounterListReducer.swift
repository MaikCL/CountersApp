//import Foundation
//
//final class CounterListReducer {
//
//    static func reduce(_ state: CounterListState, _ action: CounterListAction) -> CounterListState {
//        let semaphore = DispatchSemaphore(value: 0)
//        var currentState = state
//        switch action {
//            case .fetchCounters:
//                currentState.counters = .loading
//                currentState.exception = .none
//                currentState.runningSideEffect = .whenFetchCounters
//                semaphore.signal()
//
//            case .fetchCountersSuccess(let results):
//                currentState.counters = .loaded(results)
//                currentState.exception = .none
//                currentState.runningSideEffect = .none
//                semaphore.signal()
//
//            case .fetchCountersFailed(let exception):
//                currentState.counters = .neverLoaded
//                currentState.exception = exception
//                currentState.runningSideEffect = .none
//                semaphore.signal()
//
//            case .incrementCounter(let counter):
//                currentState.runningSideEffect = .whenIncrementCounter(counter)
//                semaphore.signal()
//                
//            case .incrementCounterSuccess(let results):
//                currentState.counters = .loaded(results)
//                currentState.exception = .none
//                currentState.runningSideEffect = .none
//                semaphore.signal()
//
//            case .incrementCounterFailed(let exception):
//                currentState.exception = exception
//                currentState.runningSideEffect = .none
//                semaphore.signal()
//
//            case .decrementCounter(let counter):
//                currentState.runningSideEffect = .whenDecrementCounter(counter)
//                semaphore.signal()
//
//            case .decrementCounterSuccess(let results):
//                currentState.counters = .loaded(results)
//                currentState.exception = .none
//                currentState.runningSideEffect = .none
//                semaphore.signal()
//
//            case .decrementCounterFailed(let exception):
//                currentState.exception = exception
//                currentState.runningSideEffect = .none
//                semaphore.signal()
//
//            case .searchCounters(let term, let counters):
//                currentState.exception = .none
//                currentState.searchedCounters = []
//                currentState.runningSideEffect = .whenSearchCounters(term: term, counters: counters)
//                semaphore.signal()
//
//            case .searchCountersSuccess(let results):
//                currentState.exception = .none
//                currentState.searchedCounters = results
//                currentState.runningSideEffect = .none
//                semaphore.signal()
//
//            case .searchCountersFailed(let exception):
//                currentState.exception = exception
//                currentState.searchedCounters = []
//                currentState.runningSideEffect = .none
//                semaphore.signal()
//
//            case .finishSearchCounters:
//                currentState.exception = .none
//                currentState.searchedCounters = []
//                currentState.runningSideEffect = .none
//                semaphore.signal()
//
//            case .deleteCounters(let counters):
//                currentState.exception = .none
//                currentState.runningSideEffect = .whenDeleteCounters(counters)
//                semaphore.signal()
//
//            case .deleteCountersCompleted(let results, let exception):
//                currentState.exception = exception
//                currentState.runningSideEffect = .none
//                if let results = results { currentState.counters = .loaded(results) }
//                semaphore.signal()
//
//        }
//        semaphore.wait()
//        return currentState
//    }
//
//}
