//
//  CompleteOrder.swift
//  
//
//  Created by harsh karanpuria on 6/28/15.
//
//

import Foundation
import CoreData

class CompleteOrder: NSManagedObject {

    @NSManaged var category: String
    @NSManaged var cost: String
    @NSManaged var date: String
    @NSManaged var drop_address: String
    @NSManaged var drop_name: String
    @NSManaged var drop_phone: String
    @NSManaged var drop_pincode: String
    @NSManaged var imageloc: String
    @NSManaged var imageobj: NSData
    @NSManaged var order_status: String
    @NSManaged var orderid: String
    @NSManaged var paid: String
    @NSManaged var pickup_address: String
    @NSManaged var pickup_name: String
    @NSManaged var pickup_phone: String
    @NSManaged var pickup_pincode: String
    @NSManaged var time: String
    @NSManaged var total_cost: String
    @NSManaged var tracking_no: String
    @NSManaged var email: String

}
