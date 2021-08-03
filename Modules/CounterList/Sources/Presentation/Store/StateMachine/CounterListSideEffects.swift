import Combine
import Resolver
import AltairMDKCommon

enum SideEffectTask {
    case none
    case whenFetchCounters
}

final class CounterListSideEffects {
    @Injected private var fetchCountersUseCase: FetchCountersUseCaseProtocol
    
    func whenInput(action: AnyPublisher<CounterListAction, Never>) -> SideEffect<CounterListState, CounterListAction> {
        SideEffect { _ in action }
    }
    
    func whenFetchCounters() -> SideEffect<CounterListState, CounterListAction> {
        SideEffect { state -> AnyPublisher<CounterListAction, Never> in
            guard case .whenFetchCounters = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.fetchCountersUseCase
                .execute()
                .map { !$0.isEmpty ? .fetchCountersSuccess($0) : .fetchCountersFailed(CounterException.noCountersYet) }
                .catch { Just(.fetchCountersFailed($0 as? CounterException ?? CounterException.some($0))) }
                .handleEvents(receiveOutput: { input in
                    guard case let .fetchCountersFailed(exception) = input else { return }
                    self.logException(exception)
                })
                .eraseToAnyPublisher()
        }
    }
    
}

extension CounterListSideEffects {
    
    // TODO: Improve later with LoggerProvider
    private func logException(_ exception: Exception) {
        print("A SideEffect exception occurred: [\(exception.code)] \(exception.localizedDescription)")
    }

}
