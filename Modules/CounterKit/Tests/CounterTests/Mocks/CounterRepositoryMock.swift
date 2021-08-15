import Combine
import AltairMDKProviders

@testable import CounterKit

class CounterRepositoryMock: CounterRepositoryProtocol {
    let fakeCounters = FakeCounters.shared.counters
    let result: Result
    
    enum Result {
        case success
        case networkUnreachable
    }
    
    init(result: Result) {
        self.result = result
    }
    
    func fetchCounters() -> AnyPublisher<[Counter], Error> {
        switch result {
            case .success:
                return Just(fakeCounters).setFailureType(to: Error.self).eraseToAnyPublisher()
            case .networkUnreachable:
                return Fail(outputType: [Counter].self, failure: NetworkException.unreachable).eraseToAnyPublisher()
        }
    }
    
    func deleteCounter(id: String) -> AnyPublisher<[Counter], Error> {
        switch result {
            case .success:
                return Just(fakeCounters).setFailureType(to: Error.self).eraseToAnyPublisher()
            case .networkUnreachable:
                return Fail(outputType: [Counter].self, failure: NetworkException.unreachable).eraseToAnyPublisher()
        }
    }
    
    func createCounter(title: String) -> AnyPublisher<[Counter], Error> {
        switch result {
            case .success:
                return Just(fakeCounters).setFailureType(to: Error.self).eraseToAnyPublisher()
            case .networkUnreachable:
                return Fail(outputType: [Counter].self, failure: NetworkException.unreachable).eraseToAnyPublisher()
        }
    }
    
    func incrementCounter(id: String) -> AnyPublisher<[Counter], Error> {
        switch result {
            case .success:
                return Just(fakeCounters).setFailureType(to: Error.self).eraseToAnyPublisher()
            case .networkUnreachable:
                return Fail(outputType: [Counter].self, failure: NetworkException.unreachable).eraseToAnyPublisher()
        }
    }
    
    func decrementCounter(id: String) -> AnyPublisher<[Counter], Error> {
        switch result {
            case .success:
                return Just(fakeCounters).setFailureType(to: Error.self).eraseToAnyPublisher()
            case .networkUnreachable:
                return Fail(outputType: [Counter].self, failure: NetworkException.unreachable).eraseToAnyPublisher()
        }
    }
    
    
}
