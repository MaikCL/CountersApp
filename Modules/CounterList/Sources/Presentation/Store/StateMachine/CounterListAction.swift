import AltairMDKCommon

enum CounterListAction {
    case fetchCounters
    case fetchCountersSuccess(_ results: [Counter])
    case fetchCountersFailed(_ exception: Exception)
}
