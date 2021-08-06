import Combine
import Resolver
import Foundation
import AltairMDKCommon

final class CountersRepository: CountersRepositoryProtocol {
    @Injected private var cloudSource: CountersCloudSourceProtocol
    @Injected private var mapCloudModelToEntity: ([CounterCloudModel]) throws -> [Counter]
    
    func fetchCounters() -> AnyPublisher<[Counter], Error> {
        return cloudSource.fetchCounters().tryMap { try self.mapCloudModelToEntity($0) }.delay(for: 0.2, scheduler: RunLoop.main).eraseToAnyPublisher()
    }
    
    func incrementCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.incrementCounter(id: id).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
    func decrementCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.decrementCounter(id: id).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
    func deleteCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.deleteCounter(id: id).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
}
