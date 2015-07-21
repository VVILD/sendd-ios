import Foundation
import CoreData

public class DataHelper {
	let context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext) {
		self.context = context
	}
	
	public func printAllZoos() {
		let zooFetchRequest = NSFetchRequest(entityName: "Zoo")
		let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		
		zooFetchRequest.sortDescriptors = [primarySortDescriptor]
		
		let allZoos = context.executeFetchRequest(zooFetchRequest, error: nil) as! [Zoo]
		
		for zoo in allZoos {
			print("Zoo Name: \(zoo.name)\nLocation: \(zoo.location) \n-------\n")
		}
	}
	
}