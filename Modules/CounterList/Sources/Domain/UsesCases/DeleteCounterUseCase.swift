import Combine
import Resolver
import AltairMDKCommon

final class DeleteCounterUseCase: DeleteCounterUseCaseProtocol {
    @Injected private var countersRepo: CountersRepositoryProtocol
    
    func execute(id: String) -> AnyPublisher<[Counter], Error> {
        return countersRepo.deleteCounter(id: id)
    }
    
}
