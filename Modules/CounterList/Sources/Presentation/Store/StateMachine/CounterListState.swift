import AltairMDKCommon

struct CounterListState {
    var counters: Loadable<[Counter]>
    var exception: CounterException?
    var titleException: String?
    var runningSideEffect: SideEffectTask
}

extension CounterListState {
    static var initial: CounterListState {
        .init(
            counters: .neverLoaded,
            exception: .none,
            titleException: .none,
            runningSideEffect: .none
        )
    }
}
