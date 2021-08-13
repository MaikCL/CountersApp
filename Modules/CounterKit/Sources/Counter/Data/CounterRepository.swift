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
        return cloudSource.deleteCounter(id: id).handleEvents(receiveOutput: { counters in
            self.localSource.deleteCounter(id: id)
                .receive(on: DispatchQueue.global(qos: .background))
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                .store(in: &self.cancellables)
        })
        .eraseToAnyPublisher()
    }
    
    func createCounter(title: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.createCounter(title: title).handleEvents(receiveOutput: { counters in
            self.localSource.saveCounters(counters: counters)
                .receive(on: DispatchQueue.global(qos: .background))
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                .store(in: &self.cancellables)
        })
        .eraseToAnyPublisher()
    }
    
    func incrementCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.incrementCounter(id: id)
            .handleEvents(receiveOutput: { counters in
            self.localSource.saveCounters(counters: counters)
                .receive(on: DispatchQueue.global(qos: .background))
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                .store(in: &self.cancellables)
        })
        .eraseToAnyPublisher()
    }
    
    func decrementCounter(id: String) -> AnyPublisher<[Counter], Error> {
        return cloudSource.decrementCounter(id: id).handleEvents(receiveOutput: { counters in
            self.localSource.saveCounters(counters: counters)
                .receive(on: DispatchQueue.global(qos: .background))
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                .store(in: &self.cancellables)
        })
        .eraseToAnyPublisher()
    }

}
