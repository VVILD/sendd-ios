import UIKit
import Alamofire
import SCLAlertView

class RateCalculatorViewController: UIViewController, UITextFieldDelegate,NSURLSessionDelegate{
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var BulkPrice: UILabel!
    @IBOutlet weak var StandardPrice: UILabel!
    @IBOutlet weak var PremiumPrice: UILabel!
    @IBOutlet weak var BulkDays: UILabel!
    @IBOutlet weak var StandardDays: UILabel!
    @IBOutlet weak var PremiumDays: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var pincodeTextField: UITextField!
    var URL:String = NetworkUtils().URL
    
    @IBAction func GetPrice(sender: AnyObject) {
        view.endEditing(true)
        if(!pincodeTextField.text.isEmpty){
            if(!weightTextField.text.isEmpty){
                if(count(pincodeTextField.text) == 6){
                 let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Loading", subTitle: "Please Wait", closeButtonTitle: "Cancel")
                    Alamofire.request(.POST, URL + "priceapp/", parameters: ["pincode": pincodeTextField.text,"weight":weightTextField.text ],encoding: .JSON ).responseJSON() {
                        (_, _, data, error) in
                        
                        if error == nil {
                            println(data)
                            let jsonDictionary = (data as! NSDictionary)
                            let StandardPrice1: AnyObject? = jsonDictionary["standard"]
                            let PremiumPrice1: AnyObject? = jsonDictionary["premium"]
                            let BulkPrice1: AnyObject? = jsonDictionary["economy"]
                            Alamofire.request(.POST, self.URL + "dateapp/", parameters: ["pincode": self.pincodeTextField.text ], encoding: .JSON ).responseJSON() {
                                (_, _, data, error) in
                                println(data)
                                
                                if error == nil {
                                    let jsonDictionary = (data as! NSDictionary)
                                    let StandardDay1: AnyObject? = jsonDictionary["standard"]
                                    let PremiumDay1: AnyObject? = jsonDictionary["premium"]
                                    let BulkDay1: AnyObject? = jsonDictionary["economy"]
                                    self.StandardDays.text =  StandardDay1 as? String
                                    self.PremiumDays.text =  PremiumDay1 as? String
                                    self.BulkDays.text =  BulkDay1 as? String
                                    self.StandardPrice.text =  StandardPrice1?.stringValue
                                    self.BulkPrice.text =  BulkPrice1?.stringValue
                                    self.PremiumPrice.text =  PremiumPrice1?.stringValue
                                    alertview.close()
                                }
                            }
                        }
                        println(data)
                        
                    }

                }else{
                    let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter a correct pincode", closeButtonTitle: "Dismiss" )
                }
            }else{
                let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter a weight", closeButtonTitle: "Dismiss" )
            }
        }else{
            let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter a pincode", closeButtonTitle: "Dismiss" )
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
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
        // Dispose of any resources that can be recreated.
    }
    
         
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
