import APIs
import Combine
import Resolver
import AltairMDKProviders

final class CountersCloudSource: CountersCloudSourceProtocol {
    @Injected private var networkProvider: NetworkProviderProtocol
    
    func fetchCounters<T>() -> AnyPublisher<T, NetworkException> where T: Decodable {
        return networkProvider.agent.run(CounterAPI.getCounters())
    }
    
    func deleteCounter<T>(id: String) -> AnyPublisher<T, NetworkException> where T: Decodable {
        return networkProvider.agent.run(CounterAPI.deleteCounter(id: id))
    }
    
    func incrementCounter<T>(id: String) -> AnyPublisher<T, NetworkException> where T: Decodable {
        return networkProvider.agent.run(CounterAPI.incrementCounter(id: id))
    }
    
    func decrementCounter<T>(id: String) -> AnyPublisher<T, NetworkException> where T: Decodable {
        return networkProvider.agent.run(CounterAPI.decrementCounter(id: id))
    }
    
}
