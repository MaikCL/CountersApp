import Combine
import Resolver
import AltairMDKCommon

final class FetchCountersUseCase: FetchCountersUseCaseProtocol {
    @Injected private var counterRepo: CounterRepositoryProtocol
    
    func execute() -> AnyPublisher<[Counter], Error> {
        return counterRepo.fetchCounters()
    }
    
}
