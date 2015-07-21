//
//  UpcomingShipmentsViewController.swift
//  Sendd
//
//  Created by harsh karanpuria on 6/24/15.
//  Copyright (c) 2015 CrazymindTechnology. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView
import Async
class UpcomingShipmentsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate {
    
    internal var context: NSManagedObjectContext!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("called UpcomingShipmentsViewController")
        
    }
    var TrackingId = ""

    var Image1: [UIImage] = []
    var Addresses: [String] = []
    var Names: [String] = []
    var TrackingNumber: [String] = []
    @IBOutlet var tableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidLoad() {
        let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Loading", subTitle: "Please Wait", closeButtonTitle: "Cancel")
        Async.background {
            println("This is run on the background queue")
            }.main {
                var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                var context:NSManagedObjectContext = appDel.managedObjectContext!
                var request = NSFetchRequest(entityName: "CompleteOrder")
                request.returnsObjectsAsFaults  =  false
                var results = context.executeFetchRequest(request, error: nil)  as! [CompleteOrder]?
                if(results?.count > 0){
                    println(results)
                    for result: CompleteOrder in results!{
                        if result.order_status == "P"{
                        self.Addresses.append(result.drop_address)
                        self.Names.append(result.drop_name)
                        self.TrackingNumber.append(result.tracking_no)
                        self.Image1.append(UIImage(data: result.imageobj)!)
                        }
                    }
                }
                alertview.close()
                self.tableView.reloadData()
                
        }
        
    }
    
    //    //On Selecting A Row
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    //        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //        var context:NSManagedObjectContext = appDel.managedObjectContext!
    //        var request = NSFetchRequest(entityName: "RecieverAddress")
    //        request.returnsObjectsAsFaults  =  false
    //        var results = context.executeFetchRequest(request, error: nil)  as! [RecieverAddress]?
    //        var counter = 0
    //        var selectedRow:RecieverAddress!
    //        if(results?.count > 0){
    //            for result: RecieverAddress in results!{
    //                if(indexPath.row == counter){
    //                    selectedRow = result
    //                }
    //                counter++
    //            }
    //
    //            let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Adding Parcel", subTitle: "Please Wait...", closeButtonTitle: "Cancel")
    //            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
    //
    //                var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //                var context2:NSManagedObjectContext = appDel.managedObjectContext!
    //                var newItem = NSEntityDescription.insertNewObjectForEntityForName("ListItem", inManagedObjectContext: context2) as! ListItem
    //                newItem.setValue(selectedRow.name, forKey: "name")
    //                newItem.setValue(selectedRow.phone, forKey: "phone")
    //                newItem.setValue(selectedRow.flat_no, forKey: "flat_no")
    //                newItem.setValue(selectedRow.locality, forKey: "locality")
    //                newItem.setValue(selectedRow.city, forKey: "city")
    //                newItem.setValue(selectedRow.state, forKey: "state")
    //                newItem.setValue(selectedRow.country, forKey: "country")
    //                newItem.setValue(selectedRow.pincode, forKey: "pincode")
    //                newItem.setValue(UIImageJPEGRepresentation(self.image,0.2), forKey: "imagedata")
    //                newItem.setValue("Set Shipping Option", forKey: "shippingoption")
    //                newItem.setValue(NSUserDefaults.standardUserDefaults().objectForKey("OrderID"), forKey: "orderid")
    //                newItem.setValue(NSDate(), forKey: "date")
    //                context2.save(nil)
    //                dispatch_async(dispatch_get_main_queue()) { // 2
    //                    alertview.close()
    //                    self.performSegueWithIdentifier("AddressPicked", sender:self)
    //
    //                }
    //            }
    //        }
    //
    //    }
    
    //On Selecting A Row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        TrackingId = TrackingNumber[indexPath.row]

        self.performSegueWithIdentifier("OpenDetails", sender:self)
    }
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return Names.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell",
                forIndexPath: indexPath) as! PreviousShipmentPendingTableCell
            cell.selectionStyle = .None
            cell.ItemImage.image = Image1[indexPath.row]
            cell.TrackingNumber!.text = TrackingNumber[indexPath.row]
            cell.NameLabel!.text = Names[indexPath.row]
            cell.AddressLabel!.text = Addresses[indexPath.row]
            
            return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "OpenDetails"){
            let destinationVC = segue.destinationViewController as! ShipmentDetailsViewController
            destinationVC.TrackingId = TrackingId
        }
    }

}



