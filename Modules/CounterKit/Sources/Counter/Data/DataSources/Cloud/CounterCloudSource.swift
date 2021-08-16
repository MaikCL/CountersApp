import APIsKit
import Combine
import Resolver
import AltairMDKProviders

final class CounterCloudSource: CounterCloudSourceProtocol {
    @Injected private var networkProvider: NetworkProviderProtocol
    @Injected private var mapCloudModelToEntity: ([CounterCloudModel]) throws -> [Counter]
    
    func fetchCounters() -> AnyPublisher<[Counter], Error> {
        return networkProvider.agent.run(CounterAPI.getCounters()).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
    func deleteCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return networkProvider.agent.run(CounterAPI.deleteCounter(id: id)).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
    func createCounter(title: String) -> AnyPublisher<[Counter], Error> {
        return networkProvider.agent.run(CounterAPI.createCounter(title: title)).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
    func incrementCounter(id: String) -> AnyPublisher<[Counter], Error>  {
        return networkProvider.agent.run(CounterAPI.incrementCounter(id: id)).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
    func decrementCounter(id: String) -> AnyPublisher<[Counter], Error>  {
        return networkProvider.agent.run(CounterAPI.decrementCounter(id: id)).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
}
