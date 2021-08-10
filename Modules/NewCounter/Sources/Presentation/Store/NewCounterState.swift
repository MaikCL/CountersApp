import AltairMDKCommon

struct NewCounterState {
    var countersCreated: [Counter]
    var exception: NewCounterException?
    var runningSideEffect: SideEffectTask
}

extension NewCounterState {
    static var initial: NewCounterState {
        .init(
            countersCreated: [],
            exception: .none,
            runningSideEffect: .none
        )
    }
}
