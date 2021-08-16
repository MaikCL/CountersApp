import Combine
import Resolver
import AltairMDKCommon

final class DecrementCounterUseCase: DecrementCounterUseCaseProtocol {
    @Injected private var counterRepo: CounterRepositoryProtocol
    
    func execute(id: String) -> AnyPublisher<[Counter], Error> {
        return counterRepo.decrementCounter(id: id)
    }
    
}
