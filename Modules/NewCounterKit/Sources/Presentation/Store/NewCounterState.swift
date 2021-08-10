import AltairMDKCommon

struct NewCounterState {
    var runningSideEffect: SideEffectTask
}

extension NewCounterState {
    static var initial: NewCounterState {
        .init(
            runningSideEffect: .none
        )
    }
}
