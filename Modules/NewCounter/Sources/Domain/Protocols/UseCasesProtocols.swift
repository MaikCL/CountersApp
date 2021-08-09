import Combine

protocol CreateCounterUseCaseProtocol: AnyObject {
    func execute(title: String) -> AnyPublisher<[Counter], Error>
}
