public struct CounterState {
    var counters: [Counter]
    var exception: CounterException?
    var runningSideEffect: SideEffectTask
}

public enum SideEffectTask {
    case none
    case whenFetchCounters
    case whenCreateCounter(title: String)
    case whenDeleteCounters([Counter])
    case whenIncrementCounter(Counter)
    case whenDecrementCounter(Counter)
}


extension CounterState {
    static var initial: CounterState {
        .init(
            counters: [],
            exception: .none,
            runningSideEffect: .none
        )
    }
}
