import AltairMDKCommon

class CounterLocalMapper: EntityFailableMapper {
    typealias Model = [CounterLocalModel]
    typealias Entity = [Counter]
    
    static var mapModelToEntity: ([CounterLocalModel]) throws -> [Counter] = { counterModel in
        return counterModel.map { Counter(id: $0.id, title: $0.id, count: Int($0.count)) }
    }
    
}
