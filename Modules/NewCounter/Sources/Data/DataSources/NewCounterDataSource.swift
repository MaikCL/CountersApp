import Combine
import AltairMDKProviders

protocol NewCounterCloudSourceProtocol: AnyObject {
    func createCounter<T: Decodable>(title: String) -> AnyPublisher<T, NetworkException>
}
