import AltairMDKCommon

final class NewCounterCloudMapper: EntityFailableMapper {
    typealias Model = [CounterCloudModel]
    typealias Entity = [Counter]
    
    static var mapModelToEntity: ([CounterCloudModel]) throws -> [Counter] = { models in
        return models.compactMap { model -> Counter? in
            guard let id = model.id else { return nil }
            return Counter(id: id, title: model.title ?? "", count: model.count ?? 0)
        }
    }
    
}
