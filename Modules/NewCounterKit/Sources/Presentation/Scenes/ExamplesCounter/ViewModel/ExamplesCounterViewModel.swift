import Combine
import Resolver
import CounterKit
import Foundation
import AltairMDKCommon

struct ExamplesCounterViewState {
    
}

protocol ExamplesCounterViewModelProtocol {
    var statePublisher: Published<ExamplesCounterViewState>.Publisher { get }
    var coordinator: ExamplesCounterFlow? { get set }
    
    func createExampleCounter(title: String)
}

final class ExamplesCounterViewModel: ExamplesCounterViewModelProtocol {
    var statePublisher: Published<ExamplesCounterViewState>.Publisher { $viewState }
    var coordinator: ExamplesCounterFlow?
    
    @Published private var viewState = ExamplesCounterViewState()
    
    init() {
        
    }
    
    
    func createExampleCounter(title: String) {
        // todo
    }
    
}
