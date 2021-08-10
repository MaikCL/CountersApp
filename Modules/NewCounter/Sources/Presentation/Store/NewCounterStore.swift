import Combine
import Resolver
import Foundation
import AltairMDKCommon

final class NewCounterStore {
    @Injected private var sideEffects: NewCounterSideEffects
    
    private var cancellables = Set<AnyCancellable>()
    private var input = PassthroughSubject<NewCounterAction, Never>()
    
    @Published private(set) var state: NewCounterState = .initial
    
    init() {
        Publishers.store(
            initial: state,
            reduce: NewCounterReducer.reduce(_:_:),
            scheduler: DispatchQueue.main,
            sideEffects: [
                sideEffects.whenInput(action: input.eraseToAnyPublisher()),
                sideEffects.whenCreateCounter(),
            ]
        )
        .assignNoRetain(to: \.state, on: self)
        .store(in: &cancellables)
    }
    
    func trigger(_ action: NewCounterAction) {
        input.send(action)
    }
    
}

