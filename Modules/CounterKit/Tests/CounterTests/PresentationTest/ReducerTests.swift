    import XCTest
    import Combine
    import Resolver
    
    @testable import CounterKit

    final class ReducerTests: XCTestCase {
        var initialState: CounterState! = nil
        
        func testReduceFetchCounter() {
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .fetchCounters)
           
            XCTAssertEqual(result.counters, .loading)
            XCTAssertEqual(result.runningSideEffect, .whenFetchCounters)
            XCTAssertNil(result.exception)
        }
        
        func testReduceFetchCounterSuccess() {
            initialState = .initial
            
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .fetchCountersSuccess(FakeCounters.shared.counters))
            
            XCTAssertEqual(result.counters, .loaded(FakeCounters.shared.counters))
            XCTAssertEqual(result.runningSideEffect, .none)
            XCTAssertNil(result.exception)
        }
        
        func testReduceFetchCounterFailed() {
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .fetchCountersFailed(.cantLoadCounters))
           
            XCTAssertEqual(result.counters, .neverLoaded)
            XCTAssertEqual(result.runningSideEffect, .none)
            XCTAssertNotNil(result.exception)
            XCTAssertEqual(result.exception, CounterException.cantLoadCounters)
        }
        
        func testReduceCreateCounter() {
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .createCounter(title: "demo"))
           
            XCTAssertEqual(result.exception, .none)
            XCTAssertEqual(result.runningSideEffect, .whenCreateCounter(title: "demo"))
        }
        
        func testReduceCreateCounterSuccess() {
            initialState = .initial
            
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .createCounterSuccess(FakeCounters.shared.counters))
            
            XCTAssertEqual(result.counters, .loaded(FakeCounters.shared.counters))
            XCTAssertEqual(result.runningSideEffect, .none)
            XCTAssertNil(result.exception)
        }
        
        func testReduceCreateCounterFailed() {
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .createCounterFailed(.cantCreateCounter))
           
            XCTAssertEqual(result.runningSideEffect, .none)
            XCTAssertEqual(result.exception, CounterException.cantCreateCounter)
        }
        
        func testReduceIncrementCounter() {
            initialState = .initial
            let counter = FakeCounters.shared.counters.first!
            
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .incrementCounter(counter))
            
            XCTAssertEqual(result.runningSideEffect, .whenIncrementCounter(counter))
            XCTAssertNil(result.exception)
        }
        
        func testReduceIncrementCounterSuccess() {
            initialState = CounterState(
                counters: .loaded(FakeCounters.shared.counters),
                exception: .cantCreateCounter,
                searchedCounters: FakeCounters.shared.searched,
                runningSideEffect: .whenFetchCounters)
            
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .incrementCounterSuccess(FakeCounters.shared.incremented))
            
            XCTAssertEqual(result.searchedCounters, [CounterKit.Counter(id: "ccbbaa", title: "Sushi", count: 8)])
            XCTAssertEqual(result.counters, .loaded(FakeCounters.shared.incremented))
            XCTAssertNil(result.exception)
            XCTAssertEqual(result.runningSideEffect, .none)
        }
       
        func testReduceIncrementCounterFailed() {
            let counter = FakeCounters.shared.counters.first!
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .incrementCounterFailed(.cantIncrementCounter(counter)))
           
            XCTAssertEqual(result.exception, .cantIncrementCounter(counter))
            XCTAssertEqual(result.runningSideEffect, .none)
        }
        
        func testReduceDecrementCounter() {
            initialState = .initial
            let counter = FakeCounters.shared.counters.first!
            
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .decrementCounter(counter))
            
            XCTAssertEqual(result.runningSideEffect, .whenDecrementCounter(counter))
            XCTAssertNil(result.exception)
        }
        
        func testReduceDecrementCounterSuccess() {
            initialState = CounterState(
                counters: .loaded(FakeCounters.shared.counters),
                exception: .cantCreateCounter,
                searchedCounters: FakeCounters.shared.searched,
                runningSideEffect: .whenFetchCounters)
            
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .decrementCounterSuccess(FakeCounters.shared.decremented))
            
            XCTAssertEqual(result.searchedCounters, [CounterKit.Counter(id: "ccbbaa", title: "Sushi", count: 6)])
            XCTAssertEqual(result.counters, .loaded(FakeCounters.shared.decremented))
            XCTAssertNil(result.exception)
            XCTAssertEqual(result.runningSideEffect, .none)
        }
        
        func testReduceDecrementFailed() {
            let counter = FakeCounters.shared.counters.first!
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .decrementCounterFailed(.cantDecrementCounter(counter)))
           
            XCTAssertEqual(result.exception, .cantDecrementCounter(counter))
            XCTAssertEqual(result.runningSideEffect, .none)
        }
        
        func testReduceDeleteCounters() {
            let counters = FakeCounters.shared.counters
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .deleteCounters(counters))
           
            XCTAssertEqual(result.runningSideEffect, .whenDeleteCounters(counters))
            XCTAssertNil(result.exception)
        }
        
        func testReduceDeleteCountersCompleted() {
            let counters = FakeCounters.shared.counters
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .deleteCountersCompleted(results: counters, exception: .none))
           
            XCTAssertEqual(result.counters, .loaded(counters))
            XCTAssertEqual(result.runningSideEffect, .none)
            XCTAssertEqual(result.exception, .none)
        }
        
        func testReduceSearchCounters() {
            let counters = FakeCounters.shared.counters
            initialState = CounterState(counters: .loading, exception: .noCountersYet, searchedCounters: counters, runningSideEffect: .whenFetchCounters)
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .searchCounters(term: "co", counters: counters))
           
            XCTAssertEqual(result.searchedCounters, [])
            XCTAssertEqual(result.runningSideEffect, .whenSearchCounters(term: "co", counters: counters))
            XCTAssertEqual(result.exception, .none)
        }
        
        func testReduceSearchCountersSuccess() {
            let counters = FakeCounters.shared.counters
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .searchCountersSuccess(counters))
           
            XCTAssertEqual(result.searchedCounters, counters)
            XCTAssertEqual(result.runningSideEffect, .none)
            XCTAssertEqual(result.exception, .none)
        }
        
        func testReduceSearchCountersFailed() {
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .searchCountersFailed(.noSearchResults))
           
            XCTAssertEqual(result.searchedCounters, [])
            XCTAssertEqual(result.runningSideEffect, .none)
            XCTAssertEqual(result.exception, .noSearchResults)
        }
        
        func testReduceFinishSearchCounters() {
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .finishSearchCounters)
           
            XCTAssertEqual(result.searchedCounters, [])
            XCTAssertEqual(result.runningSideEffect, .none)
            XCTAssertEqual(result.exception, .none)
        }
        
        func testReduceResetException() {
            initialState = .initial
        
            let sut = CounterReducer.self
            let result = sut.reduce(initialState, .resetException)
           
            XCTAssertEqual(result.exception, .none)
        }

    }
