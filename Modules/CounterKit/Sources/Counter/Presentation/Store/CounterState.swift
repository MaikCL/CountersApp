import AltairMDKCommon

public struct CounterState {
    public var counters: Loadable<[Counter]>
    public var exception: CounterException?
    public var searchedCounters: [Counter]
    public var runningSideEffect: SideEffectTask
}

extension CounterState {
    public static var initial: CounterState {
        .init(
            counters: .neverLoaded,
            exception: .none,
            searchedCounters: [],
            runningSideEffect: .none
        )
    }
}

public enum SideEffectTask {
    case none
    case whenFetchCounters
    case whenCreateCounter(title: String)
    case whenSearchCounters(term: String, counters: [Counter])
    case whenDeleteCounters([Counter])
    case whenIncrementCounter(Counter)
    case whenDecrementCounter(Counter)
}
