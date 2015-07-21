
import UIKit
import CoreData
import SCLAlertView
class CustomAlertViewController : UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    var transitioner : CAVTransitioner
    
    @IBOutlet weak var TimeSlots: UIPickerView!
    @IBOutlet weak var SelectDay: UISegmentedControl!
    var dateFormatter:NSDateFormatter = NSDateFormatter()
    var SelectedDate = ""
    var SelectedTime = ""
    var AvailableTimeSlots = ["10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "01:00 PM", "01:30 PM", "02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM", "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM", "06:00 PM"]
    
    weak var ViewController: OrdersViewController?
    @IBAction func SelectDate(sender: AnyObject) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if(SelectDay.selectedSegmentIndex == 0){
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
            let hour = components.hour
            if (hour < 17) {
                var NewAvailabelTime: Array = [String]()
                var x: Int = 0
                if (hour < 9) {
                    x = 0
                } else if (hour >= 9 && hour < 17) {
                    if (hour > 30) {
                        x = (hour - 9) * 2 + 2;
                    } else {
                        x = (hour - 9) * 2 + 1;
                    }
                } else {
                    x = 0;
                }
                for (var i = x; i < 17; i++) {
                    NewAvailabelTime.append(AvailableTimeSlots[i])
                }
                AvailableTimeSlots = NewAvailabelTime
            }else{
                AvailableTimeSlots = ["No slots available"]
            }
            TimeSlots.reloadAllComponents()
            self.SelectedDate = dateFormatter.stringFromDate(NSDate())
        }
        else if(SelectDay.selectedSegmentIndex == 1){
            AvailableTimeSlots = ["10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "01:00 PM", "01:30 PM", "02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM", "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM", "06:00 PM"]
            TimeSlots.reloadAllComponents()
            
            self.SelectedDate = dateFormatter.stringFromDate(NSDate().dateByAddingTimeInterval(60*60*24*1))
        }
        else if(SelectDay.selectedSegmentIndex == 2){
            
            AvailableTimeSlots = ["10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "01:00 PM", "01:30 PM", "02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM", "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM", "06:00 PM"]
            TimeSlots.reloadAllComponents()
             self.SelectedDate = dateFormatter.stringFromDate(NSDate().dateByAddingTimeInterval(60*60*24*2))
            
        }
    }
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        self.transitioner = CAVTransitioner()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self.transitioner
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        
        
        if (hour < 17) {
            var NewAvailabelTime: Array = [String]()
            var x: Int = 0
            if (hour < 9) {
                //                x = 0;
            } else if (hour >= 9 && hour < 17) {
                if (hour > 30) {
                    x = (hour - 9) * 2 + 2;
                } else {
                    x = (hour - 9) * 2 + 1;
                }
            } else {
                x = 0;
            }
            for (var i = x; i < 17; i++) {
                NewAvailabelTime.append(AvailableTimeSlots[i])
            }
            AvailableTimeSlots = NewAvailabelTime
            SelectedTime = AvailableTimeSlots[0]
            dateFormatter.dateFormat = "yyyy-MM-dd"

            SelectedDate = dateFormatter.stringFromDate(NSDate())
            TimeSlots.reloadAllComponents()
            
        }else{
            AvailableTimeSlots = ["No slots available"]
        }
        
        TimeSlots.delegate = self
        TimeSlots.dataSource = self
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AvailableTimeSlots.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return AvailableTimeSlots[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.SelectedTime = AvailableTimeSlots[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    convenience init() {
        self.init(nibName:"CustomAlertViewController", bundle:nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    @IBAction func Dismiss(sender: AnyObject) {
         self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func doDismiss(sender:AnyObject?) {
        println(self.SelectedTime)
        println(self.SelectedDate)
        if( self.SelectedTime == "No slots available" ||  self.SelectedTime == "" ){
             let alertview : SCLAlertViewResponder = SCLAlertView().showError("No Added Parcel", subTitle: "Add parcel to continue", closeButtonTitle: "Dismiss" )
        }else{
            self.ViewController!.BookLater(self.SelectedDate , time: self.SelectedTime)
            self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
}