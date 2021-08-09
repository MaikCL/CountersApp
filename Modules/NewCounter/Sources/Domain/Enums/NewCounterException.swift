import Foundation
import AltairMDKCommon

enum NewCounterException {
    case cantCreateCounter
}

extension NewCounterException: Exception {
    
    var category: ExceptionCategory {
        .feature
    }
    
    var code: String {
        switch self {
            case .cantCreateCounter: return "nc.dm.00"
        }
    }
    
    public var errorTitle: String? {
        switch self {
            case .cantCreateCounter: return Locale.exceptionTitleCantCreateCounter.localized
        }
    }
    
    var errorDescription: String? {
        switch self {
            case .cantCreateCounter: return Locale.exceptionMessageCantCreateCounter.localized
        }
    }
    
}
