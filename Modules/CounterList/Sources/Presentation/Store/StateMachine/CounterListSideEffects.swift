import Combine
import AltairMDKCommon

enum SideEffectTask {
    case none
    case whenFetchCounters
}

final class CounterListSideEffects {
    
    func whenInput(action: AnyPublisher<CounterListAction, Never>) -> SideEffect<CounterListState, CounterListAction> {
        SideEffect { _ in action }
    }
    
}
