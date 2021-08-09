import Combine

protocol CountersRepositoryProtocol: AnyObject {
    func createCounter(title: String) -> AnyPublisher<Void, Error>
}
