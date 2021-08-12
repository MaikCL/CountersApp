import Combine
import Resolver
import AltairMDKProviders

final class CounterLocalSource: CounterLocalSourceProtocol {
    @Injected private var storageProvider: StorageProviderProtocol
    @Injected private var mapLocalModelToEntity: ([CounterLocalModel]) throws -> [Counter]
    
    func saveCounters(counters: [Counter]) -> AnyPublisher<Void, Error> {
        do {
            let localModels = try counters.map { counter -> Storable in
                guard let localModel = storageProvider.agent.create(CounterLocalModel.self) else { throw StorageException.objectNotSupported }
                localModel.id = counter.id
                localModel.title = counter.title
                localModel.count = Int32(counter.count)
                return localModel
            }
            return storageProvider.agent.insertAll(objects: localModels).mapError { $0 }.eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func fetchCounters() -> AnyPublisher<[Counter], Error> {
        return storageProvider.agent.readAll(CounterLocalModel.self, predicate: .none).tryMap { try self.mapLocalModelToEntity($0) }.eraseToAnyPublisher()
    }
    
}
