import Resolver
import AltairMDKProviders

final public class DIComponents {
    
    public static func bind() {
        
        // MARK: Presentation Layer Components
        Resolver.register { CounterModelMapper.mapEntityToModel }
    }

}
