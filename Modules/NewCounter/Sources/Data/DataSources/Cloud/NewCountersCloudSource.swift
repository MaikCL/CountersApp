import APIs
import Combine
import Resolver
import AltairMDKProviders

final class NewCountersCloudSource: NewCounterCloudSourceProtocol {
    @Injected private var networkProvider: NetworkProviderProtocol
    
    func createCounter<T>(title: String) -> AnyPublisher<T, NetworkException> where T: Decodable {
        return networkProvider.agent.run(CounterAPI.createCounter(title: title))
    }
    
}
