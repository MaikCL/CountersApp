import AltairMDKCommon

enum CounterAction {
    case fetchCounters
    case fetchCountersSuccess(_ results: [Counter])
    case fetchCountersFailed(_ exception: CounterException)
    
    case createCounter(title: String)
    case createCounterSuccess(_ results: [Counter])
    case createCounterFailed(_ exception: CounterException)
    
    case incrementCounter(_ counter: Counter)
    case incrementCounterSuccess(_ results: [Counter])
    case incrementCounterFailed(_ exception: CounterException)
    
    case decrementCounter(_ counter: Counter)
    case decrementCounterSuccess(_ results: [Counter])
    case decrementCounterFailed(_ exception: CounterException)
    
    case deleteCounters(_ counters: [Counter])
    case deleteCountersCompleted(results: [Counter]?, exception: CounterException?)
}
