import UIKit
import Alamofire
import SCLAlertView
import SwiftyJSON
import ImageLoader
import CoreData
class VerifyViewController: UIViewController {
    
    var URL:String = NetworkUtils().URL

    var phonenumber: String = ""
    @IBAction func verifyOtpButton(sender: AnyObject) {
        view.endEditing(true)
        if(!otp.text.isEmpty){
            if(count(otp.text) == 4){
                let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Registering", subTitle: "Verifying Phone number", closeButtonTitle: "Cancel")
                Alamofire.request(.PUT, URL + "user/"+phonenumber+"/", parameters: ["otp1": otp.text ,"phone": phonenumber ],encoding: .JSON).responseJSON() {
                    (_, _, data, error) in
                    println(data)
                    if error == nil {
                        let jsonDictionary = (data as! NSDictionary)
                        if(jsonDictionary["valid"]?.stringValue  == "0"){
                            let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Invalid otp", closeButtonTitle: "Dismiss" )
                        }else if(jsonDictionary["valid"]?.stringValue  == "1"){
                            Alamofire.request(.GET, self.URL + "shipment/", parameters: ["q": self.phonenumber,"limit":"100"]).responseJSON() {
                                (_, _, data, error) in
                                if error == nil {
                                    let dict = (data as! NSDictionary)
                                    println("------------jsonDictionary-----------------------------")
                                    let json = JSON(data!)
                                    let json2 = json["objects"]
                                    for var index = 0; index < json2.count; ++index {
                                        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                        var context:NSManagedObjectContext = appDel.managedObjectContext!
                                        var newOrder = NSEntityDescription.insertNewObjectForEntityForName("CompleteOrder", inManagedObjectContext: context) as! CompleteOrder
                                        newOrder.setValue(json["objects"][index]["address"].stringValue , forKey: "pickup_address")
                                        newOrder.setValue(json["objects"][index]["name"].stringValue, forKey: "pickup_name")
                                        newOrder.setValue(json["objects"][index]["phone"].stringValue, forKey: "pickup_phone")
                                        newOrder.setValue(json["objects"][index]["email"].stringValue, forKey: "email")
                                        newOrder.setValue(json["objects"][index]["pincode"].stringValue, forKey: "pickup_pincode")
                                        newOrder.setValue(json["objects"][index]["status"].stringValue, forKey: "order_status")
                                        newOrder.setValue(json["objects"][index]["time"].stringValue, forKey: "time")
                                        newOrder.setValue(json["objects"][index]["date"].stringValue, forKey: "date")
                                        newOrder.setValue(json["objects"][index]["drop_address"].stringValue, forKey: "drop_address")
                                        newOrder.setValue(json["objects"][index]["drop_phone"].stringValue, forKey: "drop_phone")
                                        newOrder.setValue(json["objects"][index]["drop_name"].stringValue, forKey: "drop_name")
                                        newOrder.setValue(json["objects"][index]["drop_pincode"].stringValue, forKey: "drop_pincode")
                                        
                                        let url = NSURL(string: json["objects"][index]["img"].stringValue)
                                        let Imagedata1 = NSData(contentsOfURL: url!)
                                        newOrder.setValue(Imagedata1, forKey: "imageobj")
                                        newOrder.setValue(json["objects"][index]["tracking_no"].stringValue, forKey: "tracking_no")
                                        newOrder.setValue(json["objects"][index]["category"].stringValue, forKey: "category")
                                        newOrder.setValue(json["objects"][index]["order"].stringValue, forKey: "orderid")
                                        println("--------------newOrder------------------")
                                        println(newOrder)
                                        println("--------------newOrder------------------")
                                        context.save(nil)
                                        
                                    }
                                    println("---------------jsonDictionary--------------------------")
                                    alertview.close()
                                    self.performSegueWithIdentifier("OpenOrderPage", sender:self)
                                    NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
                                    NSUserDefaults.standardUserDefaults().setObject( true, forKey: "LoggedIn")
                                    NSUserDefaults.standardUserDefaults().setObject( self.phonenumber, forKey: "PhoneNumber")
                                    NSUserDefaults.standardUserDefaults().setObject( "", forKey: "Code")
                                }else{
                                  println(error)
                                    alertview.close()

                                }
                                
                                }
                            }
                        
                        }
                }
            }else{
                let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Invalid otp", closeButtonTitle: "Dismiss" )
            }
        }else{
            let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter the otp", closeButtonTitle: "Dismiss" )
        }
        
    }
    @IBOutlet weak var otp: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func textFieldShouldReturn(textField: UITextField)-> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
