final class CounterListReducer {
    
    static func reduce(_ state: CounterListState, _ action: CounterListAction) -> CounterListState {
        var currentState = state
        switch action {
            case .fetchCounters:
                currentState.counters = .loading
                currentState.exception = .none
                currentState.runningSideEffect = .whenFetchCounters
                
            case .fetchCountersSuccess(let results):
                currentState.counters = .loaded(results)
                currentState.exception = .none
                currentState.runningSideEffect = .none
                
            case .fetchCountersFailed(let exception):
                currentState.counters = .neverLoaded
                currentState.exception = exception
                currentState.runningSideEffect = .none
        }
        return currentState
    }
    
}
