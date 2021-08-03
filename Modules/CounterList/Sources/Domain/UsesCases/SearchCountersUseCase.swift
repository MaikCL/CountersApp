import Combine
import AltairMDKCommon

final class SearchCountersUseCase: SearchCountersUseCaseProtocol {
    
    func execute(term: String, over counters: [Counter]) -> AnyPublisher<[Counter], Never> {
        let countersFinded = counters.filter { $0.title.lowercased().contains(term.lowercased()) }
        return Just(countersFinded).eraseToAnyPublisher()
    }
    
}
