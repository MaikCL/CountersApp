import Combine

protocol FetchCountersUseCaseProtocol: AnyObject {
    func execute() -> AnyPublisher<[Counter], Error>
}

protocol IncrementCounterUseCaseProtocol: AnyObject {
    func execute(id: String) -> AnyPublisher<[Counter], Error>
}

protocol DecrementCounterUseCaseProtocol: AnyObject {
    func execute(id: String) -> AnyPublisher<[Counter], Error>
}

protocol DeleteCounterUseCaseProtocol: AnyObject {
    func execute(id: String) -> AnyPublisher<[Counter], Error>
}

protocol SearchCountersUseCaseProtocol: AnyObject {
    func execute(term: String, over counters: [Counter]) -> AnyPublisher<[Counter], Never>
}
