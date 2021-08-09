import Combine

protocol NewCounterRepositoryProtocol: AnyObject {
    func createCounter(title: String) -> AnyPublisher<[Counter], Error>
}
