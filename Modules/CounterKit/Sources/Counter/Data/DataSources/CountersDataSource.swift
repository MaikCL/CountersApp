import Combine
import CoreData
import AltairMDKProviders

protocol CounterCloudSourceProtocol: AnyObject {
    func fetchCounters() -> AnyPublisher<[Counter], Error>
    func deleteCounter(id: String) -> AnyPublisher<[Counter], Error>
    func createCounter(title: String) -> AnyPublisher<[Counter], Error>
    func incrementCounter(id: String) -> AnyPublisher<[Counter], Error>
    func decrementCounter(id: String) -> AnyPublisher<[Counter], Error>
}

protocol CounterLocalSourceProtocol: AnyObject {
    func saveCounters(counters: [Counter]) -> AnyPublisher<Void, Error>
    func fetchCounters() -> AnyPublisher<[Counter], Error>
}
