import Combine
import Resolver
import Foundation
import AltairMDKCommon

final class CounterRepository: CounterRepositoryProtocol {
    @Injected private var cloudSource: CounterCloudSourceProtocol
    @Injected private var localSource: CounterLocalSourceProtocol
    
    @Injected private var mapCloudModelToEntity: ([CounterCloudModel]) throws -> [Counter]
    
    func fetchCounters() -> AnyPublisher<[Counter], Error> {
//        return cloudSource.fetchCounters().tryMap { try self.mapCloudModelToEntity($0) }.delay(for: 0.1, scheduler: RunLoop.main).eraseToAnyPublisher()
        return localSource.fetchCounters()
    }
    
    func deleteCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.deleteCounter(id: id).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
    func createCounter(title: String) -> AnyPublisher<[Counter], Error> {
//        return cloudSource.createCounter(title: title).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
        
        let asdf1 = Counter(id: "asd", title: "testeando 11", count: 4)
        let asdf2 = Counter(id: "qwe", title: "testeando 22", count: 2)
        let asdf3 = Counter(id: "xcv", title: "testeando 33", count: 8)
        let asdf4 = Counter(id: "dgf", title: "testeando 41", count: 1)

        
        return localSource.saveCounters(counters: [asdf1, asdf2, asdf3, asdf4]).tryMap { [] }.eraseToAnyPublisher()
    }
    
    func incrementCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.incrementCounter(id: id).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
    func decrementCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.decrementCounter(id: id).tryMap { try self.mapCloudModelToEntity($0) }.eraseToAnyPublisher()
    }
    
}
