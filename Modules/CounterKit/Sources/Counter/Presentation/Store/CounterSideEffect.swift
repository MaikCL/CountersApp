import Combine
import Resolver
import AltairMDKCommon

final class CounterSideEffects {
    @Injected private var fetchCountersUseCase: FetchCountersUseCaseProtocol
    @Injected private var deleteCounterUseCase: DeleteCounterUseCaseProtocol
    @Injected private var createCounterUseCase: CreateCounterUseCaseProtocol
    @Injected private var searchCounterUseCase: SearchCountersUseCaseProtocol
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
                .catch { self.log($0, trigger: .fetchCountersFailed(.cantLoadCounters)) }
                .eraseToAnyPublisher()
        }
    }
    
    func whenIncrementCounter() -> SideEffect<CounterState, CounterAction> {
        SideEffect { state -> AnyPublisher<CounterAction, Never> in
            guard case .whenIncrementCounter(let counter) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.incrementCounterUseCase
                .execute(id: counter.id)
                .map { .incrementCounterSuccess($0) }
                .catch { self.log($0, trigger: .incrementCounterFailed(.cantIncrementCounter(counter))) }
                .eraseToAnyPublisher()
        }
    }
    
    func whenDecrementCounter() -> SideEffect<CounterState, CounterAction> {
        SideEffect { state -> AnyPublisher<CounterAction, Never> in
            guard case .whenDecrementCounter(let counter) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.decrementCounterUseCase
                .execute(id: counter.id)
                .map { .decrementCounterSuccess($0) }
                .catch { self.log($0, trigger: .decrementCounterFailed(.cantDecrementCounter(counter))) }
                .eraseToAnyPublisher()
        }
    }
    
    func whenCreateCounter() -> SideEffect<CounterState, CounterAction> {
        SideEffect { state -> AnyPublisher<CounterAction, Never> in
            guard case .whenCreateCounter(let title) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.createCounterUseCase
                .execute(title: title)
                .map { .createCounterSuccess($0) }
                .catch { self.log($0, trigger: .createCounterFailed(.cantCreateCounter)) }
                .eraseToAnyPublisher()
        }
    }
    
    func whenSearchConters() -> SideEffect<CounterState, CounterAction> {
        SideEffect { state -> AnyPublisher<CounterAction, Never> in
            guard case .whenSearchCounters(let term, let counters) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.searchCounterUseCase
                .execute(term: term, over: counters)
                .map { !$0.isEmpty ? .searchCountersSuccess($0) : .searchCountersFailed(.noSearchResults) }
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

}

extension CounterSideEffects {
    
    // TODO: Improve later with LoggerProvider
    private func log(_ error: Error, trigger: CounterAction) -> AnyPublisher<CounterAction, Never> {
        let exception = error as? Exception ?? GenericException.unknown(error)
        print("A SideEffect exception occurred: [\(exception.code)] \(String(describing: exception.errorTitle))")
        print("Resolve triggering: \(trigger)")
        return Just(trigger).setFailureType(to: Never.self).eraseToAnyPublisher()
    }

}
