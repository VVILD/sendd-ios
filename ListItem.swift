//
//  ListItem.swift
//  
//
//  Created by harsh karanpuria on 6/28/15.
//
//

import Foundation
import CoreData

class ListItem: NSManagedObject {

    @NSManaged var city: String
    @NSManaged var country: String
    @NSManaged var date: String
    @NSManaged var flat_no: String
    @NSManaged var imagedata: NSData
    @NSManaged var imageloc: String
    @NSManaged var locality: String
    @NSManaged var name: String
    @NSManaged var orderid: String
    @NSManaged var phone: String
    @NSManaged var pincode: String
    @NSManaged var shippingoption: String
    @NSManaged var state: String

}
