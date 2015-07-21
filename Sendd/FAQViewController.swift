import UIKit

class FAQViewController: UIViewController {
    
    var sectionTitleArray : NSMutableArray = NSMutableArray()
    var sectionContentDict : NSMutableDictionary = NSMutableDictionary()
    var arrayForBool : NSMutableArray = NSMutableArray()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        arrayForBool = ["0","0","0","0","0","0","0","0","0","0","0"]
        sectionTitleArray = ["What is Sendd ?","What all items can I sendd ?","How much does it cost ?","Why do I need to sendd the picture ?","Who does the packaging? How and when is it done?","How do I make the payment ?","How will I track my parcel ? ","How much time will it take to deliver ? ","What if my shipment is damaged/lost in transit ?","How do I sendd shipments outside India? ","How to calculate the volumetric weight of the shipment?"]
        var tmp1 : NSArray = ["We are an on demand shipping service. We come to your place to pick up your items, pack them using our customized boxes (if the items are unboxed), and sendd them anywhere in the world using the most cost effective & reliable shipping options."]
        var string1 = sectionTitleArray .objectAtIndex(0) as? String
        [sectionContentDict .setValue(tmp1, forKey:string1! )]
        
        var tmp2 : NSArray = ["Currently we can pick up items that weigh less than 30 kgs. We will ship anything as long as it can fit in the backseat of a car. We do not ship alcoholic beverages, animals, firearms, cash, counterfeit items, hazardous materials, liquids, tobacco products and items prohibited by law."]
        var string2 = sectionTitleArray .objectAtIndex(1) as? String
        [sectionContentDict .setValue(tmp2, forKey:string2! )]
        
        var tmp3 : NSArray = ["We will charge you the most economical price for the shipping option you select. We don't take any extra charge for picking up of the item & packing it."]
        var string3 = sectionTitleArray .objectAtIndex(2) as? String
        [sectionContentDict .setValue(tmp3, forKey:string3! )]
        
        var tmp4 : NSArray = ["Picture is needed so that we know the size of item to pick up. The vehicles used by our pickup team vary from bikes to cars."]
        var string4 = sectionTitleArray .objectAtIndex(3) as? String
        [sectionContentDict .setValue(tmp4, forKey:string4! )]
        
        var tmp5 : NSArray = ["Packaging is done by our pick up representative for free when he/she comes for pick up. If there are multiple items in a shipment, we will provide the best possible packaging so that the shipping cost is minimized. If your item is already packed, our pick up representative may ask for that to be opened to ensure that it complies with our policies. He/she will help you pack it again in such a case."]
        var string5 = sectionTitleArray .objectAtIndex(4) as? String
        [sectionContentDict .setValue(tmp5, forKey:string5! )]
        
        var tmp6 : NSArray = ["Currently we are accepting cash payment at the time of pickup. We will soon be launching online payment options."]
        var string6 = sectionTitleArray .objectAtIndex(5) as? String
        [sectionContentDict .setValue(tmp6, forKey:string6! )]
        
        var tmp7 : NSArray = ["You can go to My Shipments option in the app & track the status of your shipment there. Also you can track it on the website using your unique tracking ID."]
        var string7 = sectionTitleArray .objectAtIndex(6) as? String
        [sectionContentDict .setValue(tmp7, forKey:string7! )]
        
        var tmp8 : NSArray = ["Currently we have three shipping options i.e. Bulk, Standard & Premium. Depending on the option you select, it can take anywhere between 1 to 7 days. "]
        var string8 = sectionTitleArray .objectAtIndex(7) as? String
        [sectionContentDict .setValue(tmp8, forKey:string8! )]
        
        var tmp9 : NSArray = ["Our safe packaging ensures minimum chances of damage. However, if the item is still received in a damaged condition, kindly contact us within 48 hours of receipt of the same.You will be compensated upto a maximum of Rs. 10,000( Rs. 50,000 if the item is insured by you at the time of booking at an extra payment of 2%) as per our Terms of Use. To know more, kindly call us on +91-8080028081 or consult with our pick up representative when he/she comes for pick up."]
        var string9 = sectionTitleArray .objectAtIndex(8) as? String
        [sectionContentDict .setValue(tmp9, forKey:string9! )]
        
        var tmp10 : NSArray = ["Currently we aren't accepting international shipments through mobile app. However, you can call us on +91-8080028081 or mail us at help@sendd.co to book an international shipment. "]
        var string10 = sectionTitleArray .objectAtIndex(9) as? String
        [sectionContentDict .setValue(tmp10, forKey:string10! )]
        
        var tmp11 : NSArray = ["The volumetric weight (in kgs) can be calculated by the following formula: length(cm)x breadth(cm)x height(cm)/5000. Shipping cost is calculated using the higher of the two weights- actual or volumetric."]
        var string11 = sectionTitleArray .objectAtIndex(10) as? String
        [sectionContentDict .setValue(tmp11, forKey:string11! )]
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(arrayForBool .objectAtIndex(section).boolValue == true)
        {
            var tps = sectionTitleArray.objectAtIndex(section) as! String
            var count1 = (sectionContentDict.valueForKey(tps)) as! NSArray
            return count1.count
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ABC"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        headerView.backgroundColor = UIColor.grayColor()
        headerView.tag = section
        
        let headerString = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.size.width-10, height: 30)) as UILabel
        headerString.text = sectionTitleArray.objectAtIndex(section) as? String
        headerView .addSubview(headerString)
        
        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        headerView.addGestureRecognizer(headerTapped)
        
        return headerView
    }
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        var indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        if (indexPath.row == 0) {
            
            var collapsed = arrayForBool.objectAtIndex(indexPath.section).boolValue
            collapsed = !collapsed;
            
            arrayForBool .replaceObjectAtIndex(indexPath.section, withObject: collapsed)
            var range = NSMakeRange(indexPath.section, 1)
            var sectionToReload = NSIndexSet(indexesInRange: range)
            self.tableView .reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let CellIdentifier = "Cell"
        var cell :UITableViewCell
        cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! UITableViewCell
        
        var manyCells : Bool = arrayForBool .objectAtIndex(indexPath.section).boolValue
        
        if (!manyCells) {
        }
        else{
            var content = sectionContentDict .valueForKey(sectionTitleArray.objectAtIndex(indexPath.section) as! String) as! NSArray
            cell.textLabel?.text = content .objectAtIndex(indexPath.row) as? String
            cell.textLabel?.numberOfLines = 0
        }
        return cell
    }
}