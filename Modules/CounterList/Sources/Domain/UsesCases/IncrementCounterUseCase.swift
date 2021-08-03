import Combine
import Resolver
import AltairMDKCommon

final class IncrementCounterUseCase: IncrementCounterUseCaseProtocol {
    @Injected private var countersRepo: CountersRepositoryProtocol
    
    func execute(id: String) -> AnyPublisher<[Counter], Error> {
        return countersRepo.incrementCounter(id: id)
    }
    
}
