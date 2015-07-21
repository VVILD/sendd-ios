import UIKit
import MobileCoreServices
import CoreData
import SCLAlertView
import Alamofire
import AFNetworking
import Async
class OrdersViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource{
    var newMedia: Bool?
    var Image: UIImage = UIImage()
    @IBOutlet var tableView: UITableView!
    var id = 0
    var PincodeToSentWithSegue: Int = 0
    var AddressesLine1: [String] = []
    var AddressesLine2: [String] = []
    var Names: [String] = []
    var Image1: [UIImage] = []
    var Drop_Phone: [String] = []
    var Drop_FlatNos: [String] = []
    var Drop_Localities: [String] = []
    var Drop_City: [String] = []
    var Drop_State: [String] = []
    var Drop_Country: [String] = []
    var Drop_Pincode: [String] = []
    var Drop_Category: [String] = []
    var couponCode:String = ""
    var category =  "P"
    
    var URL:String = NetworkUtils().URL
    
    @IBAction func PickupLater(sender: AnyObject) {
        
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("LoggedIn") as! Bool){
            if(NSUserDefaults.standardUserDefaults().objectForKey("PickupAddress") != nil){
                if(self.Names.count>0){
                    let vc = CustomAlertViewController()
                    vc.ViewController = self
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                }else{
                    let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please select from availabe time slots", closeButtonTitle: "Dismiss" )
                }
            }else{
                performSegueWithIdentifier("AddPickUpAddress", sender:self)
            }
        }else{
            performSegueWithIdentifier("openLoginPageFromOrders", sender:self)
        }
        
    }
    @IBOutlet weak var crossbutton: UIButton!
    @IBOutlet weak var ApplyCouponButton: UIButton!
    @IBOutlet weak var CouponMessage: UILabel!
    @IBAction func RemoveCoupon(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject( "", forKey: "Code")
        NSUserDefaults.standardUserDefaults().setObject( "", forKey: "CodeMessage")
        self.ApplyCouponButton.hidden = false
        self.CouponMessage.hidden = true
        self.crossbutton.hidden = true
    }
    @IBAction func ApplyCoupon(sender: AnyObject) {
        if(NSUserDefaults.standardUserDefaults().objectForKey("LoggedIn") as! Bool){
            let alert = SCLAlertView()
            let Code = alert.addTextField(title:"Enter Coupon Code")
            alert.addButton("Apply") {
                let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Verifying Promocode", subTitle: "Please Wait", closeButtonTitle: "Cancel")
                Alamofire.request(.POST, self.URL + "promocheck/", parameters: ["phone": NSUserDefaults.standardUserDefaults().objectForKey("PhoneNumber") as! String ,"code": Code.text]).responseJSON() {
                    (_, _, data, error) in
                    println(data)
                    if error == nil {
                        let jsonDictionary = (data as! NSDictionary)
                        self.CouponMessage.text = jsonDictionary["promomsg"] as? String
                        if( jsonDictionary["valid"] as! String == "Y"){
                            NSUserDefaults.standardUserDefaults().setObject( Code.text, forKey: "Code")
                            NSUserDefaults.standardUserDefaults().setObject( jsonDictionary["promomsg"] as? String , forKey: "CodeMessage")
                        }
                        self.ApplyCouponButton.hidden = true
                        self.CouponMessage.hidden = false
                        self.crossbutton.hidden = false
                        alertview.close()
                    }
                }
                
            }
            alert.showEdit("Apply Promocode", subTitle:"", closeButtonTitle: "Dismiss")
        }else{
            performSegueWithIdentifier("openLoginPageFromOrders", sender:self)
        }
    }
    @IBAction func Picknow(sender: AnyObject) {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        if(NSUserDefaults.standardUserDefaults().objectForKey("LoggedIn") as! Bool){
            if(NSUserDefaults.standardUserDefaults().objectForKey("PickupAddress") != nil){
                if(hour > 8 && hour < 18){
                    if(self.Names.count>0){
                        var AddressText:String = NSUserDefaults.standardUserDefaults().objectForKey("PickupAddress") as! String
                        var PincodeText:String = NSUserDefaults.standardUserDefaults().objectForKey("PickupPincode") as! String
                        var NameText:String = NSUserDefaults.standardUserDefaults().objectForKey("PickupName") as! String
                        var EmailText:String = NSUserDefaults.standardUserDefaults().objectForKey("PickupEmail") as! String
                        var FlatnoText:String  = NSUserDefaults.standardUserDefaults().objectForKey("PickupFlatno") as! String
                        var PhoneNumber:String = NSUserDefaults.standardUserDefaults().objectForKey("PhoneNumber") as! String
                        var todaysDate:NSDate = NSDate()
                        var dateFormatter:NSDateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "HH:mm:ss"
                        var time:String = dateFormatter.stringFromDate(todaysDate)
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        var dateeee:String = dateFormatter.stringFromDate(todaysDate)
                        let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Placing Order", subTitle: "Creating Your Order Please wait", closeButtonTitle: "Cancel")
                        
                        
                        Alamofire.request(.POST, URL + "order/", parameters: ["user":PhoneNumber,"address": AddressText ,"flat_no": FlatnoText,"pincode":PincodeText, "email":EmailText,"name":NameText,"pick_now":"Y","date":dateeee,"code": NSUserDefaults.standardUserDefaults().objectForKey("Code") as! String,
                            "time":time],encoding: .JSON).responseJSON() {
                                (_, _, data, error) in
                                println(data)
                                if error == nil {
                                    let jsonDictionary = (data as! NSDictionary)
                                    println(jsonDictionary)
                                    println("---------------------------")
                                    for var index = 0; index < self.Names.count; ++index {
                                        var drop_name = self.Names[index]
                                        var drop_flat_no = self.Drop_FlatNos[index]
                                        var drop_phone = self.Drop_Phone[index]
                                        var drop_locality = self.Drop_Localities[index]
                                        var drop_city = self.Drop_City[index]
                                        var drop_state = self.Drop_State[index]
                                        var drop_pincode =  self.Drop_Pincode[index]
                                        var drop_country =  self.Drop_Country[index]
                                        var order:String = jsonDictionary["order_no"]!.stringValue!
                                        if(self.Drop_Category[index] == "Standard"){
                                            self.category =  "S"
                                        }else if(self.Drop_Category[index] == "Bulk"){
                                            self.category =  "E"
                                        }else if(self.Drop_Category[index] == "Premium" || self.Drop_Category[index] == "Set Shipping Option"){
                                            self.category =  "P"
                                        }else{
                                            self.category =  "P"
                                        }
                                        var drop_Image = self.Image1[index]
                                        var parameters = ["img":drop_Image,"drop_name":drop_name,"drop_phone": drop_phone ,"drop_flat_no": drop_flat_no,"drop_locality":drop_locality, "drop_city":drop_city,"drop_state":drop_state,"drop_country":drop_country,"drop_pincode":drop_pincode ,"order":order,"category":self.category]
                                        let manager = AFHTTPRequestOperationManager()
                                        manager.POST( self.URL + "shipment/",
                                            parameters: parameters,
                                            constructingBodyWithBlock: { (formData : AFMultipartFormData!) -> Void in
                                                formData.appendPartWithFileData(UIImageJPEGRepresentation(drop_Image,0.2), name: "img", fileName: "img", mimeType: "image/jpeg")
                                            },
                                            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                                                println("JSON: " + responseObject.description)
                                                var dict = responseObject as! NSDictionary
                                                
                                                var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                                var context:NSManagedObjectContext = appDel.managedObjectContext!
                                                var newOrder = NSEntityDescription.insertNewObjectForEntityForName("CompleteOrder", inManagedObjectContext: context) as! CompleteOrder
                                                newOrder.setValue(dict["address"] as! String, forKey: "pickup_address")
                                                newOrder.setValue(dict["name"] as! String, forKey: "pickup_name")
                                                newOrder.setValue(dict["phone"] as! String, forKey: "pickup_phone")
                                                newOrder.setValue(dict["email"] as! String, forKey: "email")
                                                newOrder.setValue(dict["pincode"] as! String, forKey: "pickup_pincode")
                                                newOrder.setValue(dict["status"] as! String, forKey: "order_status")
                                                newOrder.setValue(dict["time"] as! String, forKey: "time")
                                                newOrder.setValue(dict["date"], forKey: "date")
                                                newOrder.setValue(dict["drop_address"] as! String, forKey: "drop_address")
                                                newOrder.setValue(dict["drop_phone"] as! String, forKey: "drop_phone")
                                                newOrder.setValue(dict["drop_name"] as! String, forKey: "drop_name")
                                                newOrder.setValue(dict["drop_pincode"] as! String, forKey: "drop_pincode")
                                                newOrder.setValue(dict["img"] as! String, forKey: "imageloc")
                                                newOrder.setValue(dict["tracking_no"] as! String, forKey: "tracking_no")
                                                newOrder.setValue(dict["category"]as! String, forKey: "category")
                                                newOrder.setValue(dict["order"] as! String, forKey: "orderid")
                                                newOrder.setValue(UIImagePNGRepresentation(drop_Image), forKey: "imageobj")
//                                                println("---------------------------------")
//                                                println(newOrder)
//                                                println("---------------------------------")
                                                context.save(nil)
                                                self.tableView.reloadData()
                                                alertview.close()
                                                NSUserDefaults.standardUserDefaults().setObject( "", forKey: "Code")
                                                NSUserDefaults.standardUserDefaults().setObject( "", forKey: "CodeMessage")
                                                self.performSegueWithIdentifier("showThankYouPage", sender:self)
                                                
                                            },
                                            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                                                println("Error: " + error.localizedDescription)
                                        })
                                    }
                                    
                                    
                                }else{
                                    println(error)
                                }
                        }
                        
                    }else{
                        let alertview : SCLAlertViewResponder = SCLAlertView().showError("No Added Parcel", subTitle: "Add parcel to continue", closeButtonTitle: "Dismiss" )
                    }
                }else{
                    let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Currently we pickup between 10am to 6pm. Choose pick later option to schedule for later.", closeButtonTitle: "Dismiss" )
                }
            }else{
                performSegueWithIdentifier("AddPickUpAddress", sender:self)            }
        }else{
            
            performSegueWithIdentifier("openLoginPageFromOrders", sender:self)
        }
    }
    @IBAction func AddParcel(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.mediaTypes = [kUTTypeImage]
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
            newMedia = true
            let seconds = 0.5
            
        }else{
            NSLog("No Camera.")
            var alert = UIAlertController(title: "No camera", message: "Please allow this app the use of your camera in settings or buy a device that has a camera.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
        self.tableView.allowsSelection = false;
    }
    @IBOutlet weak var menuButton1: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(NSUserDefaults.standardUserDefaults().objectForKey("Code") != nil){
            if(NSUserDefaults.standardUserDefaults().objectForKey("Code") as! String == "" ){
                self.ApplyCouponButton.hidden = false
                self.CouponMessage.hidden = true
                self.crossbutton.hidden = true
            }else{
                self.CouponMessage.text = NSUserDefaults.standardUserDefaults().objectForKey("CodeMessage") as? String
                self.ApplyCouponButton.hidden = true
                self.CouponMessage.hidden = false
                self.crossbutton.hidden = false
            }
        }
        if self.revealViewController() != nil {
            menuButton1.target = self.revealViewController()
            menuButton1.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "ListItem")
        request.returnsObjectsAsFaults  =  false
        //request.predicate = NSPredicate(format: "orderid = %@", 0)
        // request.predicate = NSPredicate(format: "orderid = NSUserDefaults.standardUserDefaults().objectForKey("OrderID"))
        var results = context.executeFetchRequest(request, error: nil)  as! [ListItem]?
        println(results)
        if(results?.count > 0){
            for result: ListItem in results!{
                AddressesLine1.append(result.flat_no+result.locality)
                AddressesLine2.append(result.city+" "+result.state+" "+result.country)
                Names.append(result.name)
                Image1.append(UIImage(data: result.imagedata)!)
                Drop_Phone.append(result.phone)
                Drop_FlatNos.append(result.flat_no)
                Drop_Localities.append(result.locality)
                Drop_City.append(result.city)
                Drop_State.append(result.state)
                Drop_Country.append(result.country)
                Drop_Pincode.append(result.pincode)
                Drop_Category.append(result.shippingoption)
            }
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        self.dismissViewControllerAnimated(false, completion: nil)
        
        if mediaType == (kUTTypeImage as! String) {
            Image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
                self.performSegueWithIdentifier("openAddDestination", sender:self)
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            var context:NSManagedObjectContext = appDel.managedObjectContext!
            var request = NSFetchRequest(entityName: "ListItem")
            
            request.returnsObjectsAsFaults  =  false
            var results = context.executeFetchRequest(request, error: nil)  as! [ListItem]?
            var counter = 0
            var selectedRow:ListItem!
            if(results?.count > 0){
                for result: ListItem in results!{
                    if(indexPath.row == counter){
                        selectedRow = result
                    }
                    counter++
                }
            }
            context.deleteObject(selectedRow as ListItem)
            context.save(nil)
            Names.removeAtIndex(counter - 1)
            self.tableView.deleteRowsAtIndexPaths([indexPath],
                withRowAnimation: UITableViewRowAnimation.Automatic)
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    func tableView(tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "openAddDestination"){
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destinationViewController as! AddDestinationViewController
            destinationVC.image = Image
        }else if(segue.identifier == "EditAddress"){
            let destinationVC = segue.destinationViewController as! UpdateAddressViewController
            destinationVC.id = id
        }else if (segue.identifier == "EditShippingOption"){
            let destinationVC = segue.destinationViewController as! SetShippingOptionViewController
            destinationVC.id = id
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
                forIndexPath: indexPath) as! ListItemCell
            cell.contentView.layer.borderColor = UIColorFromRGB(0xe4e4e4).CGColor!
            cell.contentView.layer.borderWidth = 0.8
            cell.RecieverName!.text = Names[indexPath.row]
            cell.RecieverAddressLine1!.text = AddressesLine1[indexPath.row]
            cell.RecieverAddressLine2!.text = AddressesLine2[indexPath.row]
            cell.ItemImage.image = Image1[indexPath.row]
            cell.SetShippingOption.tag = indexPath.row
            cell.SetShippingOption.addTarget(self, action: "OpenShippingOption:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.SetShippingOption.setTitle(Drop_Category[indexPath.row], forState: UIControlState.Normal)
            cell.EditDetails.tag = indexPath.row
            cell.EditDetails.addTarget(self, action: "OpenEditAddress:", forControlEvents: UIControlEvents.TouchUpInside)
            return cell
    }
    func OpenShippingOption(sender:UIButton){
        let buttonRow = sender.tag
        println(buttonRow)
        id = buttonRow
        self.performSegueWithIdentifier("EditShippingOption", sender:self)
        
    }
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func OpenEditAddress(sender:UIButton){
        let buttonRow = sender.tag
        println(buttonRow)
        id = buttonRow
        self.performSegueWithIdentifier("EditAddress", sender:self)
    }
    
    func BookLater(date:String, time:String){
        println(date)
        println(time)
        
        var AddressText:String = NSUserDefaults.standardUserDefaults().objectForKey("PickupAddress") as! String
        var PincodeText:String = NSUserDefaults.standardUserDefaults().objectForKey("PickupPincode") as! String
        var NameText:String = NSUserDefaults.standardUserDefaults().objectForKey("PickupName") as! String
        var EmailText:String = NSUserDefaults.standardUserDefaults().objectForKey("PickupEmail") as! String
        var FlatnoText:String  = NSUserDefaults.standardUserDefaults().objectForKey("PickupFlatno") as! String
        var PhoneNumber:String = NSUserDefaults.standardUserDefaults().objectForKey("PhoneNumber") as! String
        var time:String = time
        var dateeee:String = date
        let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Placing Order", subTitle: "Creating Your Order Please wait", closeButtonTitle: "Cancel")
        
        
        Alamofire.request(.POST, URL + "order/", parameters: ["user":PhoneNumber,"address": AddressText ,"flat_no": FlatnoText,"pincode":PincodeText, "email":EmailText,"name":NameText,"pick_now":"N","date":dateeee,"code": NSUserDefaults.standardUserDefaults().objectForKey("Code") as! String,
            "time":time],encoding: .JSON).responseJSON() {
                (_, _, data, error) in
                println(data)
                if error == nil {
                    let jsonDictionary = (data as! NSDictionary)
                    println(jsonDictionary)
                    println("---------------------------")
                    for var index = 0; index < self.Names.count; ++index {
                        var drop_name = self.Names[index]
                        var drop_flat_no = self.Drop_FlatNos[index]
                        var drop_phone = self.Drop_Phone[index]
                        var drop_locality = self.Drop_Localities[index]
                        var drop_city = self.Drop_City[index]
                        var drop_state = self.Drop_State[index]
                        var drop_pincode =  self.Drop_Pincode[index]
                        var drop_country =  self.Drop_Country[index]
                        var order:String = jsonDictionary["order_no"]!.stringValue!
                        if(self.Drop_Category[index] == "Standard"){
                            self.category =  "S"
                        }else if(self.Drop_Category[index] == "Bulk"){
                            self.category =  "E"
                        }else if(self.Drop_Category[index] == "Premium" || self.Drop_Category[index] == "Set Shipping Option"){
                            self.category =  "P"
                        }else{
                            self.category =  "P"
                        }
                        var drop_Image = self.Image1[index]
                        var parameters = ["img":drop_Image,"drop_name":drop_name,"drop_phone": drop_phone ,"drop_flat_no": drop_flat_no,"drop_locality":drop_locality, "drop_city":drop_city,"drop_state":drop_state,"drop_country":drop_country,"drop_pincode":drop_pincode ,"order":order,"category":self.category]
                        let manager = AFHTTPRequestOperationManager()
                        manager.POST( self.URL + "shipment/",
                            parameters: parameters,
                            constructingBodyWithBlock: { (formData : AFMultipartFormData!) -> Void in
                                formData.appendPartWithFileData(UIImageJPEGRepresentation(drop_Image,0.2), name: "img", fileName: "img", mimeType: "image/jpeg")
                            },
                            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                                println("JSON: " + responseObject.description)
                                var dict = responseObject as! NSDictionary
                                
                                var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                var context:NSManagedObjectContext = appDel.managedObjectContext!
                                var newOrder = NSEntityDescription.insertNewObjectForEntityForName("CompleteOrder", inManagedObjectContext: context) as! CompleteOrder
                                newOrder.setValue(dict["address"] as! String, forKey: "pickup_address")
                                newOrder.setValue(dict["name"] as! String, forKey: "pickup_name")
                                newOrder.setValue(dict["phone"] as! String, forKey: "pickup_phone")
                                newOrder.setValue(dict["email"] as! String, forKey: "email")
                                newOrder.setValue(dict["pincode"] as! String, forKey: "pickup_pincode")
                                newOrder.setValue(dict["status"] as! String, forKey: "order_status")
                                newOrder.setValue(dict["time"] as! String, forKey: "time")
                                newOrder.setValue(dateeee, forKey: "date")
                                newOrder.setValue(dict["drop_address"] as! String, forKey: "drop_address")
                                newOrder.setValue(dict["drop_phone"] as! String, forKey: "drop_phone")
                                newOrder.setValue(dict["drop_name"] as! String, forKey: "drop_name")
                                newOrder.setValue(dict["drop_pincode"] as! String, forKey: "drop_pincode")
                                newOrder.setValue(dict["img"] as! String, forKey: "imageloc")
                                newOrder.setValue(dict["tracking_no"] as! String, forKey: "tracking_no")
                                newOrder.setValue(dict["category"]as! String, forKey: "category")
                                newOrder.setValue(dict["order"] as! String, forKey: "orderid")
                                newOrder.setValue(UIImagePNGRepresentation(drop_Image), forKey: "imageobj")
                                println("--------------newOrder------------------")
                                println(newOrder)
                                println("--------------newOrder------------------")
                                context.save(nil)
                                self.tableView.reloadData()
                                alertview.close()
                                NSUserDefaults.standardUserDefaults().setObject( "", forKey: "Code")
                                NSUserDefaults.standardUserDefaults().setObject( "", forKey: "CodeMessage")
                                self.performSegueWithIdentifier("showThankYouPage", sender:self)
                                
                            },
                            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                                println("Error: " + error.localizedDescription)
                        })
                    }
                    
                    
                }else{
                    println(error)
                }
        }
    }
}
