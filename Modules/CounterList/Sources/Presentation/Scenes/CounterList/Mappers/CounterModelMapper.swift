import Counter
import AltairMDKCommon

final class CounterModelMapper: ModelMapper {
    typealias Entity = [Counter]
    typealias Model = [CounterModel]
    
    static var mapEntityToModel: ([Counter]) -> [CounterModel] = { entity in
        return entity.compactMap { CounterModel(id: $0.id, title: $0.title, count: "\($0.count)") }
    }
}
