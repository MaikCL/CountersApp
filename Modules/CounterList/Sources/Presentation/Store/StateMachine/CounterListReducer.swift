final class CounterListReducer {
    
    static func reduce(_ state: CounterListState, _ action: CounterListAction) -> CounterListState {
        var currentState = state
        switch action {
            case .fetchCounters:
                currentState.counters = .loading
                currentState.exception = .none
                currentState.titleException = .none
                currentState.runningSideEffect = .whenFetchCounters
                
            case .fetchCountersSuccess(let results):
                currentState.counters = .loaded(results)
                currentState.exception = .none
                currentState.titleException = .none
                currentState.runningSideEffect = .none
                
            case .fetchCountersFailed(let exception):
                currentState.counters = .neverLoaded
                currentState.exception = exception
                currentState.titleException = Locale.exceptionCantLoadTitle.localized
                currentState.runningSideEffect = .none
                
            case .incrementCounter(let counter):
                currentState.runningSideEffect = .whenIncrementCounter(counter)
                
            case .incrementCounterSuccess(let results):
                currentState.counters = .loaded(results)
                currentState.exception = .none
                currentState.titleException = .none
                currentState.runningSideEffect = .none
                
            case .incrementCounterFailed(let exception, let counter):
                currentState.exception = exception
                currentState.titleException = Locale.exceptionCantUpdateTitle.localized(with: counter.count + 1)
                currentState.runningSideEffect = .none
                
            case .decrementCounter(let counter):
                currentState.runningSideEffect = .whenDecrementCounter(counter)
                
            case .decrementCounterSuccess(let results):
                currentState.counters = .loaded(results)
                currentState.exception = .none
                currentState.titleException = .none
                currentState.runningSideEffect = .none
                
            case .decrementCounterFailed(let exception, let counter):
                currentState.exception = exception
                currentState.titleException = Locale.exceptionCantUpdateTitle.localized(with: counter.count - 1)
                currentState.runningSideEffect = .none
                
        }
        return currentState
    }
    
}
