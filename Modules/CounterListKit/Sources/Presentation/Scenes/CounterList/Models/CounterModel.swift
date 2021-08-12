struct CounterModel: Hashable {
    let id: String
    let title: String
    let count: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CounterModel, rhs: CounterModel) -> Bool {
        lhs.id == rhs.id
    }
}
