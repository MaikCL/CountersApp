    import XCTest
    import Combine
    import Resolver
    
    @testable import CounterKit

    final class CounterUseCasesTests: XCTestCase {
        private var cancellables: Set<AnyCancellable>!

        override func setUp() {
            super.setUp()
            cancellables = []
        }
        
        func testCreateCounterUseCaseSucess() {
            Resolver.register { CounterRepositoryMock(result: .success) }.implements(CounterRepositoryProtocol.self)
            
            var counters = [Counter]()
            var error: Error?
            let expectation = self.expectation(description: "Counters")

            let sut = CreateCounterUseCase()
            
            sut.execute(title: "bla").sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let encounteredError):
                        error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { value in
                counters = value
            }
            .store(in: &cancellables)

            waitForExpectations(timeout: 10)
            XCTAssertNil(error)
            XCTAssertEqual(counters, FakeCounters.shared.counters)
        }
        
        func testDecrementCounterUseCaseSuccess() {
            Resolver.register { CounterRepositoryMock(result: .success) }.implements(CounterRepositoryProtocol.self)
            
            var counters = [Counter]()
            var error: Error?
            let expectation = self.expectation(description: "Counters")

            let sut = DecrementCounterUseCase()
            
            sut.execute(id: "bla").sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let encounteredError):
                        error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { value in
                counters = value
            }
            .store(in: &cancellables)

            waitForExpectations(timeout: 10)
            XCTAssertNil(error)
            XCTAssertEqual(counters, FakeCounters.shared.counters)
        }

        func testDeleteCounterUseCaseSuccess() {
            Resolver.register { CounterRepositoryMock(result: .success) }.implements(CounterRepositoryProtocol.self)
            
            var counters = [Counter]()
            var error: Error?
            let expectation = self.expectation(description: "Counters")

            let sut = DeleteCounterUseCase()
            
            sut.execute(id: "bla").sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let encounteredError):
                        error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { value in
                counters = value
            }
            .store(in: &cancellables)

            waitForExpectations(timeout: 10)
            XCTAssertNil(error)
            XCTAssertEqual(counters, FakeCounters.shared.counters)
        }
        
        func testFetchCounterUseCaseSuccess() {
            Resolver.register { CounterRepositoryMock(result: .success) }.implements(CounterRepositoryProtocol.self)
            
            var counters = [Counter]()
            var error: Error?
            let expectation = self.expectation(description: "Counters")

            let sut = FetchCountersUseCase()
            
            sut.execute().sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let encounteredError):
                        error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { value in
                counters = value
            }
            .store(in: &cancellables)

            waitForExpectations(timeout: 10)
            XCTAssertNil(error)
            XCTAssertEqual(counters, FakeCounters.shared.counters)
        }

        func testIncrementCounterUseCaseSuccess() {
            Resolver.register { CounterRepositoryMock(result: .success) }.implements(CounterRepositoryProtocol.self)
            
            var counters = [Counter]()
            var error: Error?
            let expectation = self.expectation(description: "Counters")

            let sut = IncrementCounterUseCase()
            
            sut.execute(id: "bla").sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let encounteredError):
                        error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { value in
                counters = value
            }
            .store(in: &cancellables)

            waitForExpectations(timeout: 10)
            XCTAssertNil(error)
            XCTAssertEqual(counters, FakeCounters.shared.counters)
        }
        
        func testSearchCounterUseCaseSuccess() {
            var counters = [Counter]()
            var error: Error?
            let expectation = self.expectation(description: "Counters")

            let sut = SearchCountersUseCase()
            
            sut.execute(term: "co", over: FakeCounters.shared.counters).sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let encounteredError):
                        error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { value in
                counters = value
            }
            .store(in: &cancellables)

            waitForExpectations(timeout: 10)
            XCTAssertNil(error)
            XCTAssertEqual(counters.count, 4)
            XCTAssertEqual(counters[0].title, "Coffe")
            XCTAssertEqual(counters[1].title, "Piscola")
            XCTAssertEqual(counters[2].title, "Completos")
            XCTAssertEqual(counters[3].title, "MCDonald Combos")
        }
        
    }
