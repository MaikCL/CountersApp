import AltairMDKCommon

struct CounterListState {
    var counters: Loadable<[Counter]>
    var exception: CounterException?
    var searchedCounters: [Counter]
    var runningSideEffect: SideEffectTask
}

extension CounterListState {
    static var initial: CounterListState {
        .init(
            counters: .neverLoaded,
            exception: .none,
            searchedCounters: [],
            runningSideEffect: .none
        )
    }
}
