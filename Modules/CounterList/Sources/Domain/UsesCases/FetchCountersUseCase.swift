import Combine
import Resolver
import AltairMDKCommon

final class FetchCountersUseCase: FetchCountersUseCaseProtocol {
    @Injected private var countersRepo: CountersRepositoryProtocol
    
    func execute() -> AnyPublisher<[Counter], Error> {
        return countersRepo.fetchCounters()
    }
    
}
