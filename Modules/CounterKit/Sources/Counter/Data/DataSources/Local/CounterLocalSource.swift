import Combine
import Resolver
import AltairMDKProviders
import Foundation

final class CounterLocalSource: CounterLocalSourceProtocol {
    @Injected private var storageProvider: StorageProviderProtocol
    @Injected private var mapLocalModelToEntity: ([CounterLocalModel]) throws -> [Counter]
    
    func saveCounters(counters: [Counter]) -> AnyPublisher<[Counter], Error> {
        let localModels = try? counters.map { counter -> Storable in
            guard let localModel = storageProvider.agent.create(CounterLocalModel.self) else { throw StorageException.objectNotSupported }
            localModel.id = counter.id
            localModel.title = counter.title
            localModel.count = Int32(counter.count)
            return localModel
        }.compactMap { $0 }
        return deleteAllCounter().flatMap { self.storageProvider.agent.insertAll(objects: localModels ?? []) }.map { counters }.eraseToAnyPublisher()
    }
    
    func fetchCounters() -> AnyPublisher<[Counter], Error> {
        return storageProvider.agent.readAll(CounterLocalModel.self, predicate: .none).tryMap { try self.mapLocalModelToEntity($0) }.eraseToAnyPublisher()
    }
    
    func deleteCounter(id: String) -> AnyPublisher<Void, Error> {
        return storageProvider.agent.readFirst(CounterLocalModel.self, predicate: NSPredicate(format: "id==%@", id))
            .flatMap { model -> AnyPublisher<Void, Error> in
                guard let localModel = model else { return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher() }
                return self.storageProvider.agent.delete(object: localModel).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func deleteAllCounter() -> AnyPublisher<Void, Error> {
        return storageProvider.agent.deleteAll(CounterLocalModel.self, predicate: .none).eraseToAnyPublisher()
    }
}
