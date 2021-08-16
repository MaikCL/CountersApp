import AltairMDKCommon

class CounterLocalMapper: EntityFailableMapper {
    typealias Model = [CounterLocalModel]
    typealias Entity = [Counter]
    
    static var mapModelToEntity: ([CounterLocalModel]) throws -> [Counter] = { counterModel in
        return counterModel.map { Counter(id: $0.id, title: $0.title, count: Int($0.count)) }.sorted(by: { $0.id < $1.id })
    }
    
}
