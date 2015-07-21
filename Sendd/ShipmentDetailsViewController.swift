import UIKit
import Alamofire
import SCLAlertView
import SwiftyJSON
import ImageLoader
import CoreData
class ShipmentDetailsViewController: UIViewController {
    
    @IBOutlet weak var ItemImage: UIImageView!
    
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var Name: UILabel!
    var dataFromString1: NSData? = nil

    var URL:String = NetworkUtils().URL

    var TrackingId:String = ""
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func textFieldShouldReturn(textField: UITextField)-> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBOutlet weak var menuButton1: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
         let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Loading", subTitle: "Please Wait", closeButtonTitle: "Cancel")
        Alamofire.request(.GET, URL + "shipment/" + TrackingId + "/", parameters: nil ,encoding: .JSON).responseJSON() {
            (_, _, data, error) in
            if error == nil {
                println(data)
                let jsonDictionary = (data as! NSDictionary)

                var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                var context:NSManagedObjectContext = appDel.managedObjectContext!
                var request = NSFetchRequest(entityName: "CompleteOrder")
                request.predicate = NSPredicate(format: "tracking_no = %@", self.TrackingId )
                request.returnsObjectsAsFaults  =  false
                var results = context.executeFetchRequest(request, error: nil)  as! [CompleteOrder]?
                if results!.count > 0 {
                    for result: AnyObject in results! {
                        if let orderStatus: String = result.valueForKey("order_status") as? String {
                            result.setValue(jsonDictionary["status"] as? String, forKey: "order_status")
                            println("UPdated=================")
                            context.save(nil)
                        }
                    }
                } else {
                    println("No results")
                }
                self.dataFromString1 = jsonDictionary["tracking_data"]!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                if let dataFromString = jsonDictionary["tracking_data"]!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    println(jsonDictionary["img"] as! String)
                    self.Name.text = jsonDictionary["drop_name"] as? String
                    self.Address.text = jsonDictionary["drop_address"] as? String
                    self.Date.text = (jsonDictionary["date"] as? String
                        )! + " Time: " + (jsonDictionary["time"] as? String)!
                    if let price = jsonDictionary["price"] as? String{
                    self.Price.text = "Total Bill is Rs-: " + (jsonDictionary["price"] as? String)!
                    }else{
                        self.Price.text = "Total Bill is Rs-: N/A"
                    }
                    self.ItemImage.load( (jsonDictionary["img"] as? String)!)
                    alertview.close()
                }
               
            }
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "CheckTracking"){
            let destinationVC = segue.destinationViewController as! TrackingDataViewController
            destinationVC.JsonString = dataFromString1
        }
    }

}
extension String {
    
    var parseJSONString: AnyObject? {
        
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            return NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}


    