import Resolver
import AltairMDKProviders

final public class DIComponents {
    
    public static func bind() {
        
        // MARK: Data Layer Components
        Resolver.register { ExamplesCounterRepository() }.implements(ExamplesCounterRepositoryProtocol.self)
        
        // MARK: Domain Layer Components
        
        // MARK: Presentation Layer Components
        Resolver.register { NewCounterSideEffects() }
        Resolver.register { NewCounterStore() }
    }
    
}
