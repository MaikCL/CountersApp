import Combine
import Resolver
import AltairMDKCommon

final class CreateCounterUseCase: CreateCounterUseCaseProtocol {
    @Injected private var newCounterRepo: NewCounterRepositoryProtocol
    
    func execute(title: String) -> AnyPublisher<[Counter], Error> {
        return newCounterRepo.createCounter(title: title)
    }
    
}
