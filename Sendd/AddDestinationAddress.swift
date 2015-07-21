import UIKit
import CoreData
import SCLAlertView

class AddDestinationViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    
    var image : UIImage?
    var Addresses: [String] = []
    var Names: [String] = []
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "RecieverAddress")
        request.returnsObjectsAsFaults  =  false
        var results = context.executeFetchRequest(request, error: nil)  as! [RecieverAddress]?
        if(results?.count > 0){
            for result: RecieverAddress in results!{
                Addresses.append(result.flat_no+result.locality)
                Names.append(result.name)
            }
        }
    }
    
    //On Selecting A Row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "RecieverAddress")
        request.returnsObjectsAsFaults  =  false
        var results = context.executeFetchRequest(request, error: nil)  as! [RecieverAddress]?
        var counter = 0
        var selectedRow:RecieverAddress!
        if(results?.count > 0){
            for result: RecieverAddress in results!{
                if(indexPath.row == counter){
                    selectedRow = result
                }
                counter++
            }
            
            let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Adding Parcel", subTitle: "Please Wait...", closeButtonTitle: "Cancel")
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
                
                var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                var context2:NSManagedObjectContext = appDel.managedObjectContext!
                var newItem = NSEntityDescription.insertNewObjectForEntityForName("ListItem", inManagedObjectContext: context2) as! ListItem
                newItem.setValue(selectedRow.name, forKey: "name")
                newItem.setValue(selectedRow.phone, forKey: "phone")
                newItem.setValue(selectedRow.flat_no, forKey: "flat_no")
                newItem.setValue(selectedRow.locality, forKey: "locality")
                newItem.setValue(selectedRow.city, forKey: "city")
                newItem.setValue(selectedRow.state, forKey: "state")
                newItem.setValue(selectedRow.country, forKey: "country")
                newItem.setValue(selectedRow.pincode, forKey: "pincode")
                newItem.setValue(UIImageJPEGRepresentation(self.image,0.2), forKey: "imagedata")
                newItem.setValue("Set Shipping Option", forKey: "shippingoption")
                newItem.setValue(NSUserDefaults.standardUserDefaults().objectForKey("OrderID"), forKey: "orderid")
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.stringFromDate(NSDate())
                newItem.setValue(date, forKey: "date")
                context2.save(nil)
                dispatch_async(dispatch_get_main_queue()) { // 2
                    alertview.close()
                    self.performSegueWithIdentifier("AddressPicked", sender:self)
                    
                }
            }
        }
        
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
                forIndexPath: indexPath) as! AddressTableCell
            cell.Name!.text = Names[indexPath.row]
            cell.Address!.text = Addresses[indexPath.row]
            
            return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ManuallyAddAddress"){
            let destinationVC = segue.destinationViewController as! ManuallyAddDestinationViewController
            destinationVC.Image = image!
        }
    }
}