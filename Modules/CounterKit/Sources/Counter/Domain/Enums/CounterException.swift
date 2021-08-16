import AltairMDKCommon

public enum CounterException: Equatable {
    case noCountersYet
    case noSearchResults
    case cantLoadCounters
    case cantCreateCounter
    case cantIncrementCounter(Counter)
    case cantDecrementCounter(Counter)
    case cantDeleteCounters([Counter])
}

extension CounterException: Exception {
    
    public var category: ExceptionCategory {
        .feature
    }
    
    public var code: String {
        switch self {
            case .noCountersYet: return "co.dm.00"
            case .noSearchResults: return "cl.dm.01"
            case .cantLoadCounters: return "co.dm.02"
            case .cantCreateCounter: return "co.dm.03"
            case .cantIncrementCounter: return "co.dm.04"
            case .cantDecrementCounter: return "co.dm.05"
            case .cantDeleteCounters: return "co.dm.06"
        }
    }
    
    public var errorTitle: String? {
        switch self {
            case .noCountersYet:
                return Locale.exceptionTitleNoCountersYet.localized
                
            case .noSearchResults:
                return .none
                
            case .cantLoadCounters:
                return Locale.exceptionTitleCantLoad.localized
                
            case .cantCreateCounter:
                return Locale.exceptionTitleCantCreate.localized
                
            case .cantIncrementCounter(let counter):
                return Locale.exceptionTitleCantUpdate.localized(with: counter.title ,counter.count + 1)
                
            case .cantDecrementCounter(let counter):
                return Locale.exceptionTitleCantUpdate.localized(with: counter.title, counter.count - 1)
                
            case .cantDeleteCounters(let counters):
                var title = ""
                if counters.count == 1 {
                    title = counters.first?.title ?? ""
                } else {
                    title = counters.reduce("") { $0 + "\($1.title), " }
                    title.removeLast(2)
                }
                return Locale.exceptionTitleCantDelete.localized(with: title)
                
        }
    }
    
    public var errorDescription: String? {
        switch self {
            case .noCountersYet: return Locale.exceptionMessageNoCountersYet.localized
            case .noSearchResults: return Locale.exceptionMessageNoSearchResult.localized
            case .cantLoadCounters: return Locale.exceptionMessageCantLoad.localized
            case .cantCreateCounter: return Locale.exceptionMessageCantCreate.localized
            case .cantIncrementCounter: return Locale.exceptionMessageCantUpdate.localized
            case .cantDecrementCounter: return Locale.exceptionMessageCantUpdate.localized
            case .cantDeleteCounters: return Locale.exceptionMessageCantDelete.localized
        }
    }
}
