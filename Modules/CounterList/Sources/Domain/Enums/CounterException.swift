import Foundation
import AltairMDKCommon

enum CounterException {
    case noCountersYet
    case cantLoadCounters
    case cantIncrementCounter(Counter)
    case cantDecrementCounter(Counter)
    case cantDeleteCounters([Counter])
    case noSearchResults
}

extension CounterException: Exception {
    
    var category: ExceptionCategory {
        .feature
    }
    
    var code: String {
        switch self {
            case .noCountersYet: return "cl.dm.00"
            case .cantLoadCounters: return "cl.dm.01"
            case .cantIncrementCounter: return "cl.dm.02"
            case .cantDecrementCounter: return "cl.dm.03"
            case .cantDeleteCounters: return "cl.dm.04"
            case .noSearchResults: return "cl.dm.05"
        }
    }
    
    public var errorTitle: String? {
        switch self {
            case .noCountersYet:
                return Locale.exceptionTitleNoCountersYet.localized
            case .cantLoadCounters:
                return Locale.exceptionTitleCantLoad.localized
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
            case .noSearchResults:
                return .none
        }
    }
    
    var errorDescription: String? {
        switch self {
            case .noCountersYet: return Locale.exceptionMessageNoCountersYet.localized
            case .cantLoadCounters: return Locale.exceptionMessageCantLoad.localized
            case .cantIncrementCounter: return Locale.exceptionMessageCantUpdate.localized
            case .cantDecrementCounter: return Locale.exceptionMessageCantUpdate.localized
            case .cantDeleteCounters: return Locale.exceptionMessageCantDelete.localized
            case .noSearchResults: return Locale.exceptionMessageNoSearchResult.localized
        }
    }
}
