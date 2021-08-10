import Resolver
import AltairMDKProviders

final public class DIComponents {
    
    public static func bind() {
        
        // MARK: Data Layer Components
        Resolver.register { NetworkProvider(strategy: .nsUrlSession) }.implements(NetworkProviderProtocol.self)
        Resolver.register { NewCountersCloudSource() }.implements(NewCounterCloudSourceProtocol.self)
        Resolver.register { NewCounterRepository() }.implements(NewCounterRepositoryProtocol.self)
        Resolver.register { NewCounterCloudMapper.mapModelToEntity }
        
        // MARK: Domain Layer Components
        Resolver.register { CreateCounterUseCase() }.implements(CreateCounterUseCaseProtocol.self)
        
        // MARK: Presentation Layer Components
        Resolver.register { NewCounterSideEffects() }
        Resolver.register { NewCounterStore() }
    }
    
}
