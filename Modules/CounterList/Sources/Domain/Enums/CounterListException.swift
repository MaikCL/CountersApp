import Foundation
import AltairMDKCommon

enum CounterListException {
    case noSearchResults
}

extension CounterListException: Exception {
    
    var category: ExceptionCategory {
        .feature
    }
    
    var code: String {
        switch self {
            case .noSearchResults: return "cl.dm.00"
        }
    }
    
    public var errorTitle: String? {
        switch self {
            case .noSearchResults: return .none
        }
    }
    
    var errorDescription: String? {
        switch self {
            case .noSearchResults: return Locale.exceptionMessageNoSearchResult.localized
        }
    }
}
