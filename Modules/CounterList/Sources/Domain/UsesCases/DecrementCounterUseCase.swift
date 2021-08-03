import Combine
import Resolver
import AltairMDKCommon

final class DecrementCounterUseCase: DecrementCounterUseCaseProtocol {
    @Injected private var countersRepo: CountersRepositoryProtocol
    
    func execute(id: String) -> AnyPublisher<[Counter], Error> {
        return countersRepo.decrementCounter(id: id)
    }
    
}
