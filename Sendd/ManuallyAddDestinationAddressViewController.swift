//
//  ManuallyAddDestinationAddressViewController.swift
//  Sendd
//
//  Created by harsh karanpuria on 6/22/15.
//  Copyright (c) 2015 CrazymindTechnology. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView
class ManuallyAddDestinationViewController: UIViewController{
    
    var Image:UIImage = UIImage()
    @IBOutlet weak var Drop_Pincode: UITextField!
    @IBOutlet weak var Drop_Country: UITextField!
    @IBOutlet weak var Drop_State: UITextField!
    @IBOutlet weak var Drop_City: UITextField!
    @IBOutlet weak var Drop_Locality: UITextField!
    @IBOutlet weak var Drop_Flatno: UITextField!
    @IBOutlet weak var Drop_Number: UITextField!
    @IBOutlet weak var Drop_Name: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func SaveDestinationAddress(sender: AnyObject) {
        if(!Drop_Name.text.isEmpty){
            if(!Drop_Number.text.isEmpty){
                if(count(Drop_Number.text) == 10){
                    if(!Drop_Flatno.text.isEmpty){
                        if(!Drop_Locality.text.isEmpty){
                            if(!Drop_City.text.isEmpty){
                                if(!Drop_State.text.isEmpty){
                                    if(!Drop_Country.text.isEmpty){
                                        if(!Drop_Pincode.text.isEmpty){
                                            if(count(Drop_Pincode.text) == 6){
                                                view.endEditing(true)
                                                let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Adding Parcel", subTitle: "Please Wait...", closeButtonTitle: "Cancel")
                                                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                                                    
                                                    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                                    var context:NSManagedObjectContext = appDel.managedObjectContext!
                                                    var newAddress = NSEntityDescription.insertNewObjectForEntityForName("RecieverAddress", inManagedObjectContext: context) as! RecieverAddress
                                                    newAddress.setValue(self.Drop_Name.text, forKey: "name")
                                                    newAddress.setValue(self.Drop_Number.text, forKey: "phone")
                                                    newAddress.setValue(self.Drop_Flatno.text, forKey: "flat_no")
                                                    newAddress.setValue(self.Drop_Locality.text, forKey: "locality")
                                                    newAddress.setValue(self.Drop_City.text, forKey: "city")
                                                    newAddress.setValue(self.Drop_State.text, forKey: "state")
                                                    newAddress.setValue(self.Drop_Country.text, forKey: "country")
                                                    newAddress.setValue(self.Drop_Pincode.text, forKey: "pincode")
                                                    context.save(nil)
//                                                    println("-------------------------------------------------")
//                                                    println(self.Drop_Number.text+self.Drop_Name.text+self.Drop_Flatno.text+self.Drop_Locality.text+self.Drop_City.text+self.Drop_Country.text+self.Drop_State.text+self.Drop_Pincode.text)
//                                                    println("-------------------------------------------------")
                                                    var context2:NSManagedObjectContext = appDel.managedObjectContext!
                                                    var newItem = NSEntityDescription.insertNewObjectForEntityForName("ListItem", inManagedObjectContext: context2) as! ListItem
                                                    newItem.setValue(self.Drop_Name.text, forKey: "name")
                                                    newItem.setValue(self.Drop_Number.text, forKey: "phone")
                                                    newItem.setValue(self.Drop_Flatno.text, forKey: "flat_no")
                                                    newItem.setValue(self.Drop_Locality.text, forKey: "locality")
                                                    newItem.setValue(self.Drop_City.text, forKey: "city")
                                                    newItem.setValue(self.Drop_State.text, forKey: "state")
                                                    newItem.setValue(self.Drop_Country.text, forKey: "country")
                                                    newItem.setValue(self.Drop_Pincode.text, forKey: "pincode")
                                                    newItem.setValue(UIImagePNGRepresentation(self.Image), forKey: "imagedata")
                                                    newItem.setValue("Set Shipping Option", forKey: "shippingoption")
                                                    let dateFormatter = NSDateFormatter()
                                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                                    let date = dateFormatter.stringFromDate(NSDate())
                                                    newItem.setValue(date, forKey: "date")
                                                    newItem.setValue(NSUserDefaults.standardUserDefaults().objectForKey("OrderID"), forKey: "orderid")
                                                    context2.save(nil)
                                                    dispatch_async(dispatch_get_main_queue()) { // 2
                                                        alertview.close()
                                                        self.performSegueWithIdentifier("AddressSaved", sender:self)
                                                    }
                                                }
                                                
                                            }else{
                                                let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Enter a correct Pincode", closeButtonTitle: "Dismiss" )
                                            }
                                        }else{
                                            let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Enter Pincode", closeButtonTitle: "Dismiss" )
                                        }
                                    }else{
                                        let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Enter Country", closeButtonTitle: "Dismiss" )
                                    }
                                }else{
                                    let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Enter State", closeButtonTitle: "Dismiss" )
                                }
                            }else{
                                let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Enter City", closeButtonTitle: "Dismiss" )
                            }
                        }else{
                            let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Enter Locality", closeButtonTitle: "Dismiss" )
                        }
                    }else{
                        let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Enter Flat/House No", closeButtonTitle: "Dismiss" )
                    }
                }else{
                    let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Enter 10 digit Phone Number", closeButtonTitle: "Dismiss" )
                }
            }else{
                let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Enter a Phone Number", closeButtonTitle: "Dismiss" )
            }
        }else{
            let alertview : SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "Enter a Name", closeButtonTitle: "Dismiss" )
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func textFieldShouldReturn(textField: UITextField)-> Bool{
        textField.resignFirstResponder()
        return true
    }
    
}
