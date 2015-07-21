import UIKit
import SCLAlertView
import CoreData
class MenuController: UITableViewController, UITableViewDataSource{
    
    @IBOutlet weak var UserPhoneNumber: UILabel!
    @IBOutlet weak var LoginLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 7
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 6){
             if(NSUserDefaults.standardUserDefaults().objectForKey("LoggedIn") != nil){
                if(NSUserDefaults.standardUserDefaults().objectForKey("LoggedIn") as! Bool){
                    let alert = SCLAlertView()
                    alert.addButton("Logout") {
                        NSUserDefaults.standardUserDefaults().setObject( true, forKey: "firstTimeUser")
                        NSUserDefaults.standardUserDefaults().setObject( false, forKey: "LoggedIn")
                        NSUserDefaults.standardUserDefaults().setObject( 0, forKey: "OrderID")
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("PickupAddress")
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("PickupPincode")
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("PickupName")
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("PickupEmail")
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("PickupFlatno")
                        NSUserDefaults.standardUserDefaults().setObject( false, forKey: "IsDataSynced")
                        NSUserDefaults.standardUserDefaults().setObject( "", forKey: "Code")
                        NSUserDefaults.standardUserDefaults().setObject( "" , forKey: "CodeMessage")
                        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        var context:NSManagedObjectContext = appDel.managedObjectContext!
                        var request = NSFetchRequest(entityName: "ListItem")
                        request.returnsObjectsAsFaults  =  false
                        var results = context.executeFetchRequest(request, error: nil)  as! [ListItem]?
                        if(results?.count > 0){
                            for result: ListItem in results!{
                                context.deleteObject(result as NSManagedObject)
                            }
                            results?.removeAll(keepCapacity: false)
                            context.save(nil)
                        }
                        var request2 = NSFetchRequest(entityName: "RecieverAddress")
                        request2.returnsObjectsAsFaults  =  false
                        var results2 = context.executeFetchRequest(request2, error: nil)  as! [RecieverAddress]?
                        if(results2?.count > 0){
                            for result2: RecieverAddress in results2!{
                                context.deleteObject(result2 as NSManagedObject)
                            }
                            results2?.removeAll(keepCapacity: false)
                            context.save(nil)
                        }

                        var request3 = NSFetchRequest(entityName: "CompleteOrder")
                        request3.returnsObjectsAsFaults  =  false
                        var results3 = context.executeFetchRequest(request3, error: nil)  as! [CompleteOrder]?
                        if(results3?.count > 0){
                            for result3: CompleteOrder in results3!{
                                context.deleteObject(result3 as NSManagedObject)
                            }
                            results3?.removeAll(keepCapacity: false)
                            context.save(nil)
                        }

                        self.performSegueWithIdentifier("LoggedOut", sender:self)
                    }
                    alert.showWarning("Logout", subTitle: "Are you sure you want to Logout?" ,closeButtonTitle: "Dismiss")
                }else{
                    println("OpenLoginpage")
                    performSegueWithIdentifier("openLoginPage", sender:self)
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         if(NSUserDefaults.standardUserDefaults().objectForKey("LoggedIn") != nil){
            if(NSUserDefaults.standardUserDefaults().objectForKey("LoggedIn") as! Bool){
                UserPhoneNumber.text = NSUserDefaults.standardUserDefaults().objectForKey("PhoneNumber") as? String
                LoginLable.text = "Logout"
            }else{
                UserPhoneNumber.text = "Sendd"
                LoginLable.text = "Login"
            }
        }
        self.tableView.reloadData()
    }
}
