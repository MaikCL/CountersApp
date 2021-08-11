import Combine
import Resolver
import AltairMDKCommon

enum SideEffectTask {
    case none
}

final class NewCounterSideEffects {

    func whenInput(action: AnyPublisher<NewCounterAction, Never>) -> SideEffect<NewCounterState, NewCounterAction> {
        SideEffect { _ in action }
    }

}

extension NewCounterSideEffects {

    private func logException(_ exception: Exception) {
        print("A SideEffect exception occurred: [\(exception.code)] \(String(describing: exception.errorTitle))")
    }

}
