import Combine
import Resolver
import Foundation
import AltairMDKCommon

protocol CreateCounterViewModelProtocol {
    var coordinator: CreateCounterFlow? { get set }
}

final class CreateCounterViewModel: CreateCounterViewModelProtocol {
    var coordinator: CreateCounterFlow?
    
}
