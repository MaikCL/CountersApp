import Foundation
import AltairMDKCommon

enum CounterException {
    case some(Error)
    case unknown
    case noCountersYet
    case cantLoadCounters
    case cantIncrementCounter(_ counter: Counter)
    case cantDecrementCounter(_ counter: Counter)
    case cantDeleteCounter(_ counter: Counter)
    case noSearchResults
}

extension CounterException: Exception {
    
    var category: ExceptionCategory {
        .feature
    }
    
    var code: String {
        switch self {
            case .some:
                return "cl.dm.00"
            case .unknown:
                return "cl.dm.01"
            case .noCountersYet:
                return "cl.dm.02"
            case .cantLoadCounters:
                return "cl.dm.03"
            case .cantIncrementCounter:
                return "cl.dm.04"
            case .cantDecrementCounter:
                return "cl.dm.05"
            case .cantDeleteCounter:
                return "cl.dm.06"
            case .noSearchResults:
                return "cl.dm.07"
        }
    }
    
    var errorDescription: String? {
        switch self {
            
            case .some(let error):
                return "Exception with underlying Error: \(error.localizedDescription)"
            case .unknown:
                return "An unknown exception has occurred"
            case .noCountersYet:
                return "The Internet connection appears to be offline"
            case .cantLoadCounters:
                return "The Internet connection appears to be offline"
            case .cantIncrementCounter:
                return "The Internet connection appears to be offline"
            case .cantDecrementCounter:
                return "The Internet connection appears to be offline"
            case .cantDeleteCounter:
                return "The Internet connection appears to be offline"
            case .noSearchResults:
                return "No results"
        }
    }
}
