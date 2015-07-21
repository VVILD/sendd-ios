import UIKit
import SCLAlertView
import CoreLocation
import Alamofire
import SAMTextView

class PickupAddressViewController: UIViewController ,CLLocationManagerDelegate{
    var manager:CLLocationManager!
    @IBOutlet weak var AddressTextField: SAMTextView!
    @IBOutlet weak var PincodeTextField: UITextField!
    @IBOutlet weak var NameTextfield: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var FlatnoTextField: UITextField!
    var URL:String = NetworkUtils().URL
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField)-> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func SaveDetails(sender: AnyObject) {
        view.endEditing(true)
        if(!AddressTextField.text.isEmpty){
            if(!PincodeTextField.text.isEmpty){
                if(!NameTextfield.text.isEmpty){
                    if(!EmailTextField.text.isEmpty){
                        if(!FlatnoTextField.text.isEmpty){
                            if(isValidEmail(EmailTextField.text)){
                                if(count(PincodeTextField.text) == 6){
                                    let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Loading", subTitle: "Please Wait", closeButtonTitle: "Cancel")
                                    Alamofire.request(.POST, URL + "pincodecheck/", parameters: ["pincode": PincodeTextField.text] ,encoding: .JSON).responseJSON() {
                                        (_, _, data, error) in
                                        alertview.close()
                                        if error == nil {
                                            let jsonDictionary = (data as! NSDictionary)
                                            println(jsonDictionary)
                                            if(jsonDictionary["valid"]?.stringValue  == "0"){
                                                let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: jsonDictionary["msg"] as! String, closeButtonTitle: "Dismiss" )
                                            }else if(jsonDictionary["valid"]?.stringValue  == "1"){
                                                NSUserDefaults.standardUserDefaults().setObject( self.AddressTextField.text, forKey: "PickupAddress")
                                                NSUserDefaults.standardUserDefaults().setObject( self.PincodeTextField.text, forKey: "PickupPincode")
                                                NSUserDefaults.standardUserDefaults().setObject( self.NameTextfield.text, forKey: "PickupName")
                                                NSUserDefaults.standardUserDefaults().setObject( self.EmailTextField.text, forKey: "PickupEmail")
                                                NSUserDefaults.standardUserDefaults().setObject( self.FlatnoTextField.text, forKey: "PickupFlatno")
                                                self.performSegueWithIdentifier("SaveAddress", sender:self)
                                            }
                                        }
                                    }
                                    
                                }else{
                                    let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter a correct pincode", closeButtonTitle: "Dismiss" )
                                }
                            }else{
                                let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter a valid email address", closeButtonTitle: "Dismiss" )
                            }
                        }else{
                            let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter a flatno", closeButtonTitle: "Dismiss" )
                        }
                    }else{
                        let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter a email", closeButtonTitle: "Dismiss" )
                    }
                }else{
                    let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter a name", closeButtonTitle: "Dismiss" )
                }
            }else{
                let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter a pincode", closeButtonTitle: "Dismiss" )
            }
        }else{
            let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter complete address", closeButtonTitle: "Dismiss" )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddressTextField.placeholder = "Street Address"
        AddressTextField.layer.borderWidth = 1
        AddressTextField.layer.cornerRadius = 10
        AddressTextField.layer.borderColor = UIColor(rgba: "#e4e4e4").CGColor
        self.scrollview.keyboardDismissMode = .OnDrag
        if(NSUserDefaults.standardUserDefaults().objectForKey("PickupAddress") != nil){
            AddressTextField.text = NSUserDefaults.standardUserDefaults().objectForKey("PickupAddress") as? String
            PincodeTextField.text = NSUserDefaults.standardUserDefaults().objectForKey("PickupPincode") as? String
            NameTextfield.text = NSUserDefaults.standardUserDefaults().objectForKey("PickupName") as? String
            EmailTextField.text = NSUserDefaults.standardUserDefaults().objectForKey("PickupEmail") as? String
            FlatnoTextField.text = NSUserDefaults.standardUserDefaults().objectForKey("PickupFlatno") as? String
        }else{
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy - kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation:CLLocation = locations[0] as! CLLocation
        
        NSUserDefaults.standardUserDefaults().setObject( "\(userLocation.coordinate.latitude)", forKey: "Lat")
        NSUserDefaults.standardUserDefaults().setObject( "\(userLocation.coordinate.longitude)", forKey: "Long")
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            if (error != nil) {
                println(error)
                
            } else {
                
                if let p = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark) {
                    
                    var subThoroughfare:String = ""
                    var thoroughfare:String = ""
                    var subLocality:String = ""
                    var subAdministrativeArea:String = ""
                    var postalCode:String = ""
                    var country:String = ""
                    
                    if (p.subThoroughfare != nil) {
                        subThoroughfare = p.subThoroughfare
                    }
                    if(p.thoroughfare != nil){
                        thoroughfare = p.thoroughfare
                    }
                    if(p.subLocality != nil){
                        subLocality = p.subLocality 
                    }
                    if(p.subAdministrativeArea != nil){
                        subAdministrativeArea = p.subAdministrativeArea
                    }
                    if(p.postalCode != nil){
                        postalCode = p.postalCode
                    }
                    if(p.country != nil){
                        country = p.country
                    }
                    self.AddressTextField.text = subThoroughfare+" "+thoroughfare+" "+subLocality+" "+subAdministrativeArea+" "+country
                    self.PincodeTextField.text = postalCode
                    
                }
            }
        })
    }
}
