import Combine

protocol CountersRepositoryProtocol: AnyObject {
    func fetchCounters() -> AnyPublisher<[Counter], Error>
    func incrementCounter(id: String) -> AnyPublisher<[Counter], Error>
    func decrementCounter(id: String) -> AnyPublisher<[Counter], Error>
    func deleteCounter(id: String) -> AnyPublisher<[Counter], Error>
}
