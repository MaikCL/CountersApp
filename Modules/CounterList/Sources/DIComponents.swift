import Resolver

final public class DIComponents {
    
    public static func bind() {
        
        // MARK: Domain Components
        Resolver.register { FetchCountersUseCase() }.implements(FetchCountersUseCaseProtocol.self)
        Resolver.register { DeleteCounterUseCase() }.implements(DeleteCounterUseCaseProtocol.self)
        Resolver.register { SearchCountersUseCase() }.implements(SearchCountersUseCaseProtocol.self)
        Resolver.register { IncrementCounterUseCase() }.implements(IncrementCounterUseCaseProtocol.self)
        Resolver.register { DecrementCounterUseCase() }.implements(DecrementCounterUseCaseProtocol.self)
        
    }
    
}
