import CoreData
import Foundation
import AltairMDKProviders

@objc(CounterLocalModel)
class CounterLocalModel: NSManagedObject, Storable {
    static var entityName: String = "Counter"

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var count: Int32

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CounterLocalModel> {
        return NSFetchRequest<CounterLocalModel>(entityName: entityName)
    }

}


