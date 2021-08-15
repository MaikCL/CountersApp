@testable import CounterKit

class FakeCounters {
    
    static let shared = FakeCounters()
    
    private init() { }
    
    var counters: [Counter] = {
        let counter1 = Counter(id: "aaaaaa", title: "Coffe", count: 12)
        let counter2 = Counter(id: "aaaabb", title: "Beer", count: 3)
        let counter3 = Counter(id: "aabbaa", title: "Tea", count: 20)
        let counter4 = Counter(id: "aabbcc", title: "Juice", count: 11)
        let counter5 = Counter(id: "ccbbaa", title: "Sushi", count: 7)
        let counter6 = Counter(id: "bbccaa", title: "Piscola", count: 4)
        let counter7 = Counter(id: "aaaaaa", title: "Completos", count: 12)
        let counter8 = Counter(id: "aaaaaa", title: "MCDonald Combos", count: 10)
        return [counter1, counter2, counter3, counter4, counter5, counter6, counter7, counter8]
    }()
    
}
