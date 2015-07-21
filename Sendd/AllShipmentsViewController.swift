//
//  AllShipmentsViewController.swift
//  Sendd
//
//  Created by harsh karanpuria on 6/24/15.
//  Copyright (c) 2015 CrazymindTechnology. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView
import Async

class AllShipmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate {
    internal var context: NSManagedObjectContext!
    var TrackingId = ""
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("called AllShipmentsViewController")
        
    }
    var Image1: [UIImage] = []
    var Addresses: [String] = []
    var Names: [String] = []
    var TrackingNumber: [String] = []
    @IBOutlet var tableView: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        self.Addresses.append(result.drop_address)
                        self.Names.append(result.drop_name)
                        self.TrackingNumber.append(result.tracking_no)
                        self.Image1.append(UIImage(data: result.imageobj)!)
                    }
                }
                alertview.close()
                self.tableView.reloadData()
                
        }
    }
    
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
                forIndexPath: indexPath) as! PreviousShipmentAllTableCell
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
