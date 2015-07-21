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

class UpdateAddressViewController: UIViewController{
    
    var id = 0
    var selectedRow:ListItem!
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
        view.endEditing(true)
        if(!self.Drop_Name.text.isEmpty){
            if(!self.Drop_Number.text.isEmpty){
                if(count(Drop_Number.text) == 10){
                    if(!self.Drop_Flatno.text.isEmpty){
                        if(!self.Drop_Locality.text.isEmpty){
                            if(!self.Drop_City.text.isEmpty){
                                if(!self.Drop_State.text.isEmpty){
                                    if(!self.Drop_Country.text.isEmpty){
                                        if(!self.Drop_Pincode.text.isEmpty){
                                            if(count(Drop_Pincode.text) == 6){
                                                
                                                let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Updating", subTitle: "Please Wait...", closeButtonTitle: "Cancel")
                                                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
                                                    
                                                    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                                    var context:NSManagedObjectContext = appDel.managedObjectContext!
                                                    self.selectedRow.setValue(self.Drop_Name.text, forKey: "name")
                                                    self.selectedRow.setValue(self.Drop_Number.text, forKey: "phone")
                                                    self.selectedRow.setValue(self.Drop_Flatno.text, forKey: "flat_no")
                                                    self.selectedRow.setValue(self.Drop_Locality.text, forKey: "locality")
                                                    self.selectedRow.setValue(self.Drop_City.text, forKey: "city")
                                                    self.selectedRow.setValue(self.Drop_State.text, forKey: "state")
                                                    self.selectedRow.setValue(self.Drop_Country.text, forKey: "country")
                                                    self.selectedRow.setValue(self.Drop_Pincode.text, forKey: "pincode")
                                                    context.save(nil)
                                                    dispatch_async(dispatch_get_main_queue()) { // 2
                                                        alertview.close()
                                                        self.performSegueWithIdentifier("UpdateAddress", sender:self)
                                                        
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

        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "ListItem")
        
        request.returnsObjectsAsFaults  =  false
        var results = context.executeFetchRequest(request, error: nil)  as! [ListItem]?
        var counter = 0
        
        if(results?.count > 0){
            for result: ListItem in results!{
                if(id == counter){
                    selectedRow = result
                }
                counter++
            }
        }
        self.Drop_Pincode.text = String(_cocoaString: selectedRow.pincode)
        self.Drop_Country.text = selectedRow.country
        self.Drop_State.text = selectedRow.state
        self.Drop_City.text = selectedRow.city
        self.Drop_Locality.text = selectedRow.locality
        self.Drop_Flatno.text = selectedRow.flat_no
        self.Drop_Number.text = selectedRow.phone
        self.Drop_Name.text = selectedRow.name
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func textFieldShouldReturn(textField: UITextField)-> Bool{
        textField.resignFirstResponder()
        return true
    }
    
}
