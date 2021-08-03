import AltairMDKCommon

struct CounterListState {
    var counters: Loadable<[Counter]>
    var exception: Exception?
    var runningSideEffect: SideEffectTask
}

extension CounterListState {
    static var initial: CounterListState {
        .init(
            counters: .neverLoaded,
            exception: .none,
            runningSideEffect: .none
        )
    }
}
