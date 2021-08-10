import Foundation

final class NewCounterReducer {
    
    static func reduce(_ state: NewCounterState, _ action: NewCounterAction) -> NewCounterState {
        var currentState = state
        switch action {
            case .createCounter(let title):
                currentState.countersCreated = []
                currentState.exception = .none
                currentState.runningSideEffect = .whenCreateCounter(title: title)
                
            case .createCounterSuccess(let results):
                currentState.countersCreated = results
                currentState.exception = .none
                currentState.runningSideEffect = .none
                
            case .createCounterFailed(let exception):
                currentState.countersCreated = []
                currentState.exception = exception
                currentState.runningSideEffect = .none
        }
        return currentState
    }

}
