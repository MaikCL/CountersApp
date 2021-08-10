import Combine
import Resolver
import Foundation
import AltairMDKCommon

final class CounterStore {
    @Injected private var sideEffects: CounterSideEffects
    
    private var cancellables = Set<AnyCancellable>()
    private var input = PassthroughSubject<CounterAction, Never>()
    
    @Published private(set) var state: CounterState = .initial
    
    init() {
        Publishers.store(
            initial: state,
            reduce: CounterReducer.reduce(_:_:),
            scheduler: DispatchQueue.main,
            sideEffects: [
                sideEffects.whenFetchCounters(),
                sideEffects.whenDeleteCounter(),
                sideEffects.whenCreateCounter(),
                sideEffects.whenIncrementCounter(),
                sideEffects.whenDecrementCounter(),
                sideEffects.whenInput(action: input.eraseToAnyPublisher()),
            ]
        )
        .assignNoRetain(to: \.state, on: self)
        .store(in: &cancellables)
    }
    
    func trigger(_ action: CounterAction) {
        input.send(action)
    }
    
}
