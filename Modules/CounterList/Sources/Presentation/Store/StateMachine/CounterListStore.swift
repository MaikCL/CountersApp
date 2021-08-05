import Combine
import Resolver
import Foundation
import AltairMDKCommon

final class CounterListStore {
    @Injected private var sideEffects: CounterListSideEffects
    
    private var cancellables = Set<AnyCancellable>()
    private var input = PassthroughSubject<CounterListAction, Never>()
    
    @Published private(set) var state: CounterListState = .initial
    
    init() {
        Publishers.store(
            initial: state,
            reduce: CounterListReducer.reduce(_:_:),
            scheduler: DispatchQueue.main,
            sideEffects: [
                sideEffects.whenInput(action: input.eraseToAnyPublisher()),
                sideEffects.whenFetchCounters(),
                sideEffects.whenIncrementCounter(),
                sideEffects.whenDecrementCounter()
            ]
        )
        .assignNoRetain(to: \.state, on: self)
        .store(in: &cancellables)
    }
    
    func trigger(_ action: CounterListAction) {
        input.send(action)
    }
    
}
