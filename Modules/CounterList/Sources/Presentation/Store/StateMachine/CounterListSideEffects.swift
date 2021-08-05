import Combine
import Resolver
import AltairMDKCommon

enum SideEffectTask {
    case none
    case whenFetchCounters
    case whenIncrementCounter(Counter)
    case whenDecrementCounter(Counter)
}

final class CounterListSideEffects {
    @Injected private var fetchCountersUseCase: FetchCountersUseCaseProtocol
    @Injected private var incrementCounterUseCase: IncrementCounterUseCaseProtocol
    @Injected private var decrementCounterUseCase: DecrementCounterUseCaseProtocol
    
    func whenInput(action: AnyPublisher<CounterListAction, Never>) -> SideEffect<CounterListState, CounterListAction> {
        SideEffect { _ in action }
    }
    
    func whenFetchCounters() -> SideEffect<CounterListState, CounterListAction> {
        SideEffect { state -> AnyPublisher<CounterListAction, Never> in
            guard case .whenFetchCounters = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.fetchCountersUseCase
                .execute()
                .map { !$0.isEmpty ? .fetchCountersSuccess($0) : .fetchCountersFailed(CounterException.noCountersYet) }
                .replaceError(with: .fetchCountersFailed(.cantLoadCounters))
                .handleEvents(receiveOutput: { input in
                    guard case let .fetchCountersFailed(exception) = input else { return }
                    self.logException(exception)
                })
                .eraseToAnyPublisher()
        }
    }
    
    func whenIncrementCounter() -> SideEffect<CounterListState, CounterListAction> {
        SideEffect { state -> AnyPublisher<CounterListAction, Never> in
            guard case .whenIncrementCounter(let counter) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.incrementCounterUseCase
                .execute(id: counter.id)
                .map { .incrementCounterSuccess($0) }
                .replaceError(with: .incrementCounterFailed(.cantIncrementCounter, counter: counter))
                .handleEvents(receiveOutput: { input in
                    guard case let .incrementCounterFailed(exception, _) = input else { return }
                    self.logException(exception)
                })
                .eraseToAnyPublisher()
        }
    }
    
    func whenDecrementCounter() -> SideEffect<CounterListState, CounterListAction> {
        SideEffect { state -> AnyPublisher<CounterListAction, Never> in
            guard case .whenDecrementCounter(let counter) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.decrementCounterUseCase
                .execute(id: counter.id)
                .map { .decrementCounterSuccess($0) }
                .replaceError(with: .decrementCounterFailed(.cantDecrementCounter, counter: counter))
                .handleEvents(receiveOutput: { input in
                    guard case let .decrementCounterFailed(exception, _) = input else { return }
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
