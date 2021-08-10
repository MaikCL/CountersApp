import Combine
import Resolver
import AltairMDKCommon

final class CounterSideEffects {
    @Injected private var fetchCountersUseCase: FetchCountersUseCaseProtocol
    @Injected private var deleteCounterUseCase: DeleteCounterUseCaseProtocol
    @Injected private var createCounterUseCase: CreateCounterUseCaseProtocol
    @Injected private var incrementCounterUseCase: IncrementCounterUseCaseProtocol
    @Injected private var decrementCounterUseCase: DecrementCounterUseCaseProtocol
    
    func whenInput(action: AnyPublisher<CounterAction, Never>) -> SideEffect<CounterState, CounterAction> {
        SideEffect { _ in action }
    }
    
    func whenFetchCounters() -> SideEffect<CounterState, CounterAction> {
        SideEffect { state -> AnyPublisher<CounterAction, Never> in
            guard case .whenFetchCounters = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.fetchCountersUseCase
                .execute()
                .map { !$0.isEmpty ? .fetchCountersSuccess($0) : .fetchCountersFailed(.noCountersYet) }
                .replaceError(with: .fetchCountersFailed(.cantLoadCounters))
                .handleEvents(receiveOutput: { input in
                    guard case let .fetchCountersFailed(exception) = input else { return }
                    self.logException(exception)
                })
                .eraseToAnyPublisher()
        }
    }
    
    func whenDeleteCounter() -> SideEffect<CounterState, CounterAction> {
        SideEffect { state -> AnyPublisher<CounterAction, Never> in
            guard case .whenDeleteCounters(let counters) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            let publishers = counters.compactMap { counter -> AnyPublisher<Result<[Counter], Error>, Never> in
                self.deleteCounterUseCase
                    .execute(id: counter.id)
                    .map { .success($0) }
                    .catch { Just(.failure($0)) }
                    .handleEvents(receiveOutput: { input in
                        guard case .failure = input else { return }
                        self.logException(CounterException.cantDeleteCounters(counters))
                    })
                    .eraseToAnyPublisher()
            }
            
            return Publishers.MergeMany(publishers)
                .collect()
                .map { publishersResults in
                    let lastResult = try? publishersResults.last(where: { $0.isSuccess })?.get()
                    var exception: CounterException?
                    var countersNotDeleted = counters
                    if let lastResult = lastResult {
                        if lastResult.isEmpty { exception = .noCountersYet }
                        let countersToDelete: Set<Counter> = Set(counters)
                        let countersLastResult: Set<Counter> = Set(lastResult)
                        countersNotDeleted = Array(countersToDelete.intersection(countersLastResult))
                    }
                    exception = publishersResults.first(where: { $0.isFailure }) == nil ? exception : .cantDeleteCounters(countersNotDeleted)
                    return .deleteCountersCompleted(results: lastResult, exception: exception)
                }
                .eraseToAnyPublisher()
        }
    }
    
    func whenIncrementCounter() -> SideEffect<CounterState, CounterAction> {
        SideEffect { state -> AnyPublisher<CounterAction, Never> in
            guard case .whenIncrementCounter(let counter) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.incrementCounterUseCase
                .execute(id: counter.id)
                .map { .incrementCounterSuccess($0) }
                .replaceError(with: .incrementCounterFailed(.cantIncrementCounter(counter)))
                .handleEvents(receiveOutput: { input in
                    guard case let .incrementCounterFailed(exception) = input else { return }
                    self.logException(exception)
                })
                .eraseToAnyPublisher()
        }
    }
    
    func whenDecrementCounter() -> SideEffect<CounterState, CounterAction> {
        SideEffect { state -> AnyPublisher<CounterAction, Never> in
            guard case .whenDecrementCounter(let counter) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.decrementCounterUseCase
                .execute(id: counter.id)
                .map { .decrementCounterSuccess($0) }
                .replaceError(with: .decrementCounterFailed(.cantDecrementCounter(counter)))
                .handleEvents(receiveOutput: { input in
                    guard case let .decrementCounterFailed(exception) = input else { return }
                    self.logException(exception)
                })
                .eraseToAnyPublisher()
        }
    }
    
    func whenCreateCounter() -> SideEffect<CounterState, CounterAction> {
        SideEffect { state -> AnyPublisher<CounterAction, Never> in
            guard case .whenCreateCounter(let title) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.createCounterUseCase
                .execute(title: title)
                .map { .createCounterSuccess($0) }
                .replaceError(with:  .createCounterFailed(.cantCreateCounter))
                .handleEvents(receiveOutput: { input in
                    guard case let .createCounterFailed(exception) = input else { return }
                    self.logException(exception)
                })
                .eraseToAnyPublisher()
        }
    }

}

extension CounterSideEffects {
    
    // TODO: Improve later with LoggerProvider
    private func logException(_ exception: Exception) {
        // Disclaimer: Eventually the exception can be logged in more detail if the error actions are handled as exceptions type.
        // In order to make the error handling simpler for this test, all the exceptions are cast to the generic "internet appear offline" message.
        // But is easly change that behavior ;)
        print("A SideEffect exception occurred: [\(exception.code)] \(String(describing: exception.errorTitle))")
    }

}
