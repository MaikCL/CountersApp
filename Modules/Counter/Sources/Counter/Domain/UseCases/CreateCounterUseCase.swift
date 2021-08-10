import Combine
import Resolver
import AltairMDKCommon

final class CreateCounterUseCase: CreateCounterUseCaseProtocol {
    @Injected private var counterRepo: CounterRepositoryProtocol
    
    func execute(title: String) -> AnyPublisher<[Counter], Error> {
        return counterRepo.createCounter(title: title)
    }
    
}
