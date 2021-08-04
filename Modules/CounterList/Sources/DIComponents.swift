import Resolver
import AltairMDKProviders

final public class DIComponents {
    
    public static func bind() {
        
        // MARK: Data Layer Components
        Resolver.register { NetworkProvider(strategy: .nsUrlSession) }.implements(NetworkProviderProtocol.self)
        Resolver.register { CountersCloudSource() }.implements(CountersCloudSourceProtocol.self)
        Resolver.register { CountersRepository() }.implements(CountersRepositoryProtocol.self)
        Resolver.register { CounterCloudMapper.mapModelToEntity }
        
        // MARK: Domain Layer Components
        Resolver.register { FetchCountersUseCase() }.implements(FetchCountersUseCaseProtocol.self)
        Resolver.register { DeleteCounterUseCase() }.implements(DeleteCounterUseCaseProtocol.self)
        Resolver.register { SearchCountersUseCase() }.implements(SearchCountersUseCaseProtocol.self)
        Resolver.register { IncrementCounterUseCase() }.implements(IncrementCounterUseCaseProtocol.self)
        Resolver.register { DecrementCounterUseCase() }.implements(DecrementCounterUseCaseProtocol.self)
        
        // MARK: Presentation Layer Components
        Resolver.register { CounterListSideEffects() }
        Resolver.register { CounterListStore() }
    }
    
}
