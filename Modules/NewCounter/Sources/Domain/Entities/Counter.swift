import Foundation

// To avoid duplication, the same counter entity proposed in the CounterList module can be used.
// But in order to avoid making a "core" package with a common domain that was only going to contain this file and nothing else, the entity was duplicated.
struct Counter: Hashable {
    let id: String
    let title: String
    let count: Int
}
