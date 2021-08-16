import UIKit

public enum Palette {
    case accent
    case background
    case buttonText
    case cellBackground
    case descriptionText
    case disabledText
    case main
    case primaryText
    case secondaryText
    case subtitleText
    case textfield
    case shadow
}

extension Palette {
    
    public var uiColor: UIColor {
        switch self {
            case .accent:
                return UIColor(named: "AccentColor", in: Bundle.module, compatibleWith: .current) ?? .clear
            case .background:
                return UIColor(named: "Background", in: Bundle.module, compatibleWith: .current) ?? .clear
            case .buttonText:
                return UIColor(named: "ButtonText", in: Bundle.module, compatibleWith: .current) ?? .clear
            case .cellBackground:
                return UIColor(named: "CellBackground", in: Bundle.module, compatibleWith: .current) ?? .clear
            case .descriptionText:
                return UIColor(named: "descriptionText", in: Bundle.module, compatibleWith: .current) ?? .clear
            case .disabledText:
                return UIColor(named: "DisabledText", in: Bundle.module, compatibleWith: .current) ?? .clear
            case .main:
                return UIColor(named: "MainColor", in: Bundle.module, compatibleWith: .current) ?? .clear
            case .primaryText:
                return UIColor(named: "PrimaryText", in: Bundle.module, compatibleWith: .current) ?? .clear
            case .secondaryText:
                return UIColor(named: "SecondaryText", in: Bundle.module, compatibleWith: .current) ?? .clear
            case .subtitleText:
                return UIColor(named: "SubtitleText", in: Bundle.module, compatibleWith: .current) ?? .clear
            case .textfield:
                return UIColor(named: "TextField", in: Bundle.module, compatibleWith: .current) ?? .clear
            case .shadow:
                return UIColor(named: "Shadow", in: Bundle.module, compatibleWith: .current) ?? .clear
        }
    }
    
    public var cgColor: CGColor {
        switch self {
            case .shadow:
                return UIColor(named: "Shadow", in: Bundle.module, compatibleWith: .current)?.cgColor ?? UIColor.clear.cgColor
            default: return UIColor.clear.cgColor
        }
    }
    
}
