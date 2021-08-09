import Combine
import Resolver
import AltairMDKCommon

final class CreateCounterUseCase: CreateCounterUseCaseProtocol {
    @Injected private var countersRepo: CountersRepositoryProtocol
    
    func execute(title: String) -> AnyPublisher<Void, Error> {
        return countersRepo.createCounter(title: title)
    }
    
}
