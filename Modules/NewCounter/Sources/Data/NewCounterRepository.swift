import Combine
import Resolver
import Foundation
import AltairMDKCommon

final class NewCounterRepository: NewCounterRepositoryProtocol {
    @Injected private var cloudSource: NewCounterCloudSourceProtocol
    @Injected private var mapCloudModelToEntity: ([CounterCloudModel]) throws -> [Counter]
    
    func createCounter(title: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.createCounter(title: title).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
}
