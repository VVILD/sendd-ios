import UIKit
import Alamofire
import SCLAlertView
class RegisterViewController: UIViewController {
    
    var URL:String = NetworkUtils().URL

    @IBOutlet weak var phoneText: UITextField!
    @IBAction func RegisterButton(sender: AnyObject) {
        view.endEditing(true)
        if(!phoneText.text.isEmpty){
            if(count(phoneText.text) == 10){
                 let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Registering", subTitle: "Please Wait", closeButtonTitle: "Cancel")
                Alamofire.request(.POST, URL + "user/", parameters: ["phone": phoneText.text] ,encoding: .JSON).responseJSON() {
                    (_, _, data, error) in
                    if error == nil {
                        self.performSegueWithIdentifier("OpenVerifyViewController", sender:self)
                        alertview.close()
                     }
                    println(data)
                }
            }else{
                let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter your 10 digit mobile number", closeButtonTitle: "Dismiss" )
            }
        }else{
             let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Please enter a Phone Number", closeButtonTitle: "Dismiss" )
        }
        
    }
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
        if self.revealViewController() != nil {
            menuButton1.target = self.revealViewController()
            menuButton1.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "OpenVerifyViewController") {
            var verifyViewController = (segue.destinationViewController as! VerifyViewController)
            verifyViewController.phonenumber = phoneText.text
        }
    }
}
