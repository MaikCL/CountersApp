import AltairMDKCommon

enum CounterListAction {
    case fetchCounters
    case fetchCountersSuccess(_ results: [Counter])
    case fetchCountersFailed(_ exception: CounterException)
    
    case incrementCounter(_ counter: Counter)
    case incrementCounterSuccess(_ results: [Counter])
    case incrementCounterFailed(_ exception: CounterException, counter: Counter)
    
    case decrementCounter(_ counter: Counter)
    case decrementCounterSuccess(_ results: [Counter])
    case decrementCounterFailed(_ exception: CounterException, counter: Counter)
    
    case searchCounters(term: String, counters: [Counter])
    case searchCountersSuccess(_ results: [Counter])
    case searchCountersFailed(_ exception: CounterException)
    case finishSearchCounters
    
    case deleteCounter(_ counter: Counter)
    case deleteCounterSuccess(_ results: [Counter])
    case deleteCounterFailed(_ exception: CounterException, counter: Counter)
}

