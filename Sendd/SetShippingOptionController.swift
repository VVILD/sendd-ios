//
//  ManuallyAddDestinationAddressViewController.swift
//  Sendd
//
//  Created by harsh karanpuria on 6/22/15.
//  Copyright (c) 2015 CrazymindTechnology. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SCLAlertView
class SetShippingOptionViewController: UIViewController{
    
    var pincode:String = ""
    var selectedRow:ListItem!
    var URL:String = NetworkUtils().URL

    var ShippingModeSelected: String = "Premium"
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var BulkDays: UILabel!
    @IBOutlet weak var StandardDays: UILabel!
    @IBOutlet weak var PremiumDays: UILabel!
    @IBOutlet weak var StandardPrice: UILabel!
    @IBOutlet weak var PremiumPrice: UILabel!
    @IBOutlet weak var BulkPrice: UILabel!
    
  
    @IBAction func SaveShippingOption(sender: AnyObject) {
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        selectedRow.setValue(ShippingModeSelected, forKey: "shippingoption")
        context.save(nil)
        self.performSegueWithIdentifier("SetShippingOption", sender:self)
    }
     @IBAction func GEtEstimate(sender: AnyObject) {
        let alert = SCLAlertView()
        let l = alert.addTextField(title:"Enter length in cm")
        let b = alert.addTextField(title:"Enter width in cm")
        let h = alert.addTextField(title:"Enter height in cm")
        let w = alert.addTextField(title:"Enter weight in cm")
        w.keyboardType = UIKeyboardType.NumberPad
        b.keyboardType = UIKeyboardType.NumberPad
        l.keyboardType = UIKeyboardType.NumberPad
        h.keyboardType = UIKeyboardType.NumberPad
        alert.addButton("Get Estimate") {
            let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Loading", subTitle: "Please Wait", closeButtonTitle: "Cancel")
            Alamofire.request(.POST, self.URL + "priceapp/", parameters: ["pincode":self.pincode,"weight":w.text,"l":l.text,"b":b.text ,"h":h.text]).responseJSON() {
                (_, _, data, error) in
                
                if error == nil {
                  //  println(data)
                    alertview.close()
                    let jsonDictionary = (data as! NSDictionary)
                    let StandardPrice1: AnyObject? = jsonDictionary["standard"]
                    let PremiumPrice1: AnyObject? = jsonDictionary["premium"]
                    let BulkPrice1: AnyObject? = jsonDictionary["economy"]
                    self.StandardPrice.text =  StandardPrice1?.stringValue
                    self.BulkPrice.text =  BulkPrice1?.stringValue
                    self.PremiumPrice.text =  PremiumPrice1?.stringValue
                }
            }
        }
        alert.showEdit("Details", subTitle:"Enter your parcel details", closeButtonTitle: "Dismiss")
    }
    
    func firstButton() {
        println("First button tapped")
    }
    

var id = 0
 
@IBAction func segmentedControlAction(sender: AnyObject) {
    
    if(segmentedControl.selectedSegmentIndex == 0)
    {
       ShippingModeSelected = "Premium"
    }
    else if(segmentedControl.selectedSegmentIndex == 1)
    {
       ShippingModeSelected = "Standard"
    }
    else if(segmentedControl.selectedSegmentIndex == 2)
    {
       ShippingModeSelected = "Bulk"
    }
}

override func viewDidLoad() {
    super.viewDidLoad()
    
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
    pincode = selectedRow.pincode
    
    if(selectedRow.shippingoption == "Premium"){
        segmentedControl.selectedSegmentIndex = 0
    }else if(selectedRow.shippingoption == "Standard"){
        segmentedControl.selectedSegmentIndex = 1
    }else if(selectedRow.shippingoption == "Bulk"){
        segmentedControl.selectedSegmentIndex = 2
    }else if(selectedRow.shippingoption == "Set Shipping Option"){
        segmentedControl.selectedSegmentIndex = 0
    }

    let alertview : SCLAlertViewResponder = SCLAlertView().showWait("Loading", subTitle: "Please Wait", closeButtonTitle: "Cancel")
    Alamofire.request(.POST, URL + "dateapp/", parameters: ["pincode": pincode ], encoding: .JSON ).responseJSON() {
        (_, _, data, error) in
        
        
        if error == nil {
            let jsonDictionary = (data as! NSDictionary)
            let StandardDay1: AnyObject? = jsonDictionary["standard"]
            let PremiumDay1: AnyObject? = jsonDictionary["premium"]
            let BulkDay1: AnyObject? = jsonDictionary["economy"]
            self.BulkDays.text = BulkDay1 as? String
            self.StandardDays.text = StandardDay1 as? String
            self.PremiumDays.text = PremiumDay1 as? String
            alertview.close()
        }
      //  println(data)
    }
    
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
