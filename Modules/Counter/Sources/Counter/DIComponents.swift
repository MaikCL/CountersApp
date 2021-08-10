import Resolver
import AltairMDKProviders

final public class DIComponents {
    
    public static func bind() {
        
        // MARK: Data Layer Components
        Resolver.register { NetworkProvider(strategy: .nsUrlSession) }.implements(NetworkProviderProtocol.self)
        Resolver.register { CounterCloudSource() }.implements(CounterCloudSourceProtocol.self)
        Resolver.register { CounterRepository() }.implements(CounterRepositoryProtocol.self)
        Resolver.register { CounterCloudMapper.mapModelToEntity }
        
        // MARK: Domain Layer Components
        Resolver.register { FetchCountersUseCase() }.implements(FetchCountersUseCaseProtocol.self)
        Resolver.register { DeleteCounterUseCase() }.implements(DeleteCounterUseCaseProtocol.self)
        Resolver.register { CreateCounterUseCase() }.implements(CreateCounterUseCaseProtocol.self)
        Resolver.register { IncrementCounterUseCase() }.implements(IncrementCounterUseCaseProtocol.self)
        Resolver.register { DecrementCounterUseCase() }.implements(DecrementCounterUseCaseProtocol.self)
        
        // MARK: Presentation Layer Components
        Resolver.register { CounterSideEffects() }
        Resolver.register { CounterStore() }
    }

}
