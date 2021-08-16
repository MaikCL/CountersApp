import Foundation

struct ExampleModel: Hashable {
    let id = UUID()
    let category: String
    let items: [ItemModel]
    
    struct ItemModel: Hashable {
        let title: String
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ExampleModel, rhs: ExampleModel) -> Bool {
        lhs.id == rhs.id
    }
}
