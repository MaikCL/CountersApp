import Combine
import Resolver
import Foundation
import AltairMDKCommon

final class CounterRepository: CounterRepositoryProtocol {
    @Injected private var cloudSource: CounterCloudSourceProtocol
    @Injected private var localSource: CounterLocalSourceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchCounters() -> AnyPublisher<[Counter], Error> {
        return cloudSource.fetchCounters()
            .delay(for: 0.2, scheduler: RunLoop.main)
            .catch { _ in
                self.localSource.fetchCounters().tryMap {
                    if $0.isEmpty { throw CounterException.cantLoadCounters } else { return $0 }
                }
            }
            .flatMap { self.localSource.saveCounters(counters: $0) }
            .eraseToAnyPublisher()
    }
    
    func deleteCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.deleteCounter(id: id)
            .flatMap { self.localSource.saveCounters(counters: $0) }
        .eraseToAnyPublisher()
    }
    
    func createCounter(title: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.createCounter(title: title)
            .flatMap { self.localSource.saveCounters(counters: $0) }
        .eraseToAnyPublisher()
    }
    
    func incrementCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.incrementCounter(id: id)
            .flatMap { self.localSource.saveCounters(counters: $0) }
            .eraseToAnyPublisher()
    }
    
    func decrementCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.decrementCounter(id: id)
            .flatMap { self.localSource.saveCounters(counters: $0) }
            .eraseToAnyPublisher()
    }

}
