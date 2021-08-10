import Combine
import Resolver
import AltairMDKCommon

enum SideEffectTask {
    case none
    case whenCreateCounter(title: String)
}

final class NewCounterSideEffects {
    @Injected private var createCounterUseCase: CreateCounterUseCaseProtocol
    
    func whenInput(action: AnyPublisher<NewCounterAction, Never>) -> SideEffect<NewCounterState, NewCounterAction> {
        SideEffect { _ in action }
    }
    
    func whenCreateCounter() -> SideEffect<NewCounterState, NewCounterAction> {
        SideEffect { state -> AnyPublisher<NewCounterAction, Never> in
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

extension NewCounterSideEffects {
    
    private func logException(_ exception: Exception) {
        print("A SideEffect exception occurred: [\(exception.code)] \(String(describing: exception.errorTitle))")
    }

}
