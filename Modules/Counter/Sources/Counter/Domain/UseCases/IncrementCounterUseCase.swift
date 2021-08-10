import Combine
import Resolver
import AltairMDKCommon

final class IncrementCounterUseCase: IncrementCounterUseCaseProtocol {
    @Injected private var counterRepo: CounterRepositoryProtocol
    
    func execute(id: String) -> AnyPublisher<[Counter], Error> {
        return counterRepo.incrementCounter(id: id)
    }
    
}
