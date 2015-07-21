//
//  ThankyouViewController.swift
//  Sendd
//
//  Created by harsh karanpuria on 6/25/15.
//  Copyright (c) 2015 CrazymindTechnology. All rights reserved.
//

import UIKit
import CoreData
class ThankyouViewController: UIViewController {
    
    @IBAction func BookAnother(sender: AnyObject) {
        performSegueWithIdentifier("orderAnother", sender:self)
        
    }
    @IBAction func PreviousBooking(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context1:NSManagedObjectContext = appDel.managedObjectContext!
        var request1 = NSFetchRequest(entityName: "ListItem")
        request1.returnsObjectsAsFaults  =  false
        var results = context1.executeFetchRequest(request1, error: nil)  as! [ListItem]?
        if(results?.count > 0){
            for result: ListItem in results!{
                context1.deleteObject(result as NSManagedObject)
            }
            results?.removeAll(keepCapacity: false)
            context1.save(nil)
        }
    }
}
