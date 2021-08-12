import Combine
import CoreData
import AltairMDKProviders

protocol CounterCloudSourceProtocol: AnyObject {
    func fetchCounters<T: Decodable>() -> AnyPublisher<T, NetworkException>
    func deleteCounter<T: Decodable>(id: String) -> AnyPublisher<T, NetworkException>
    func createCounter<T: Decodable>(title: String) -> AnyPublisher<T, NetworkException>
    func incrementCounter<T: Decodable>(id: String) -> AnyPublisher<T, NetworkException>
    func decrementCounter<T: Decodable>(id: String) -> AnyPublisher<T, NetworkException>
}

protocol CounterLocalSourceProtocol: AnyObject {
    func saveCounters(counters: [Counter]) -> AnyPublisher<Void, Error>
    func fetchCounters() -> AnyPublisher<[Counter], Error>
}
