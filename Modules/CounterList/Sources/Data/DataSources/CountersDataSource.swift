import Combine
import AltairMDKProviders

protocol CountersCloudSourceProtocol: AnyObject {
    func fetchCounters<T: Decodable>() -> AnyPublisher<T, NetworkException>
    func deleteCounter<T: Decodable>(id: String) -> AnyPublisher<T, NetworkException>
    func incrementCounter<T: Decodable>(id: String) -> AnyPublisher<T, NetworkException>
    func decrementCounter<T: Decodable>(id: String) -> AnyPublisher<T, NetworkException>
}
