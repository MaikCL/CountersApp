public struct CounterState {
    public var counters: [Counter]
    public var exception: CounterException?
    public var searchedCounters: [Counter]
    public var runningSideEffect: CounterSideEffectTask
}

public enum CounterSideEffectTask {
    case none
    case whenFetchCounters
    case whenCreateCounter(title: String)
    case whenSearchCounters(term: String, counters: [Counter])
    case whenDeleteCounters([Counter])
    case whenIncrementCounter(Counter)
    case whenDecrementCounter(Counter)
}


extension CounterState {
    static var initial: CounterState {
        .init(
            counters: [],
            exception: .none,
            searchedCounters: [],
            runningSideEffect: .none
        )
    }
}
