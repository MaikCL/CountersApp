import Combine
import Resolver
import AltairMDKCommon

final class DeleteCounterUseCase: DeleteCounterUseCaseProtocol {
    @Injected private var counterRepo: CounterRepositoryProtocol
    
    func execute(id: String) -> AnyPublisher<[Counter], Error> {
        return counterRepo.deleteCounter(id: id)
    }
    
}
