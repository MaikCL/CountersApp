import Combine
import Resolver
import AltairMDKCommon

enum SideEffectTask {
    case none
    case whenFetchCounters
    case whenDeleteCounters([Counter])
    case whenIncrementCounter(Counter)
    case whenDecrementCounter(Counter)
    case whenSearchCounters(term: String, counters: [Counter])
}

final class CounterListSideEffects {
    @Injected private var fetchCountersUseCase: FetchCountersUseCaseProtocol
    @Injected private var deleteCounterUseCase: DeleteCounterUseCaseProtocol
    @Injected private var searchCounterUseCase: SearchCountersUseCaseProtocol
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
    
    func whenDeleteCounter() -> SideEffect<CounterListState, CounterListAction> {
        SideEffect { state -> AnyPublisher<CounterListAction, Never> in
            guard case .whenDeleteCounters(let counters) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            let publishers = counters.compactMap { counter -> AnyPublisher<Result<[Counter], Error>, Never> in
                self.deleteCounterUseCase
                    .execute(id: counter.id)
                    .map { .success($0) }
                    .catch { Just(.failure($0)) }
                    .handleEvents(receiveOutput: { input in
                        guard case let .failure(error) = input else { return }
                        self.logException(CounterException.some(error))
                    })
                    .eraseToAnyPublisher()
            }
            
            return Publishers.MergeMany(publishers)
                .collect()
                .map { publishersResults in
                    let lastResult = try? publishersResults.last(where: { $0.isSuccess })?.get()
                    var exception = publishersResults.first(where: { $0.isFailure }) == nil ? nil : CounterException.cantDeleteCounter
                    var countersNotDeleted = [Counter]()
                    if let lastResult = lastResult {
                        if lastResult.isEmpty { exception = .noCountersYet }
                        let countersToDelete: Set<Counter> = Set(counters)
                        let countersLastResult: Set<Counter> = Set(lastResult)
                        countersNotDeleted = Array(countersToDelete.intersection(countersLastResult))
                    }
                    return .deleteCountersCompleted(results: lastResult, notDeleted: countersNotDeleted, exception: exception)
                }
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
    
    func whenSearchConters() -> SideEffect<CounterListState, CounterListAction> {
        SideEffect { state -> AnyPublisher<CounterListAction, Never> in
            guard case .whenSearchCounters(let term, let counters) = state.runningSideEffect else { return Empty().eraseToAnyPublisher() }
            return self.searchCounterUseCase
                .execute(term: term, over: counters)
                .map { !$0.isEmpty ? .searchCountersSuccess($0) : .searchCountersFailed(.noSearchResults) }
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
