import UIKit
import CoreData
import SCLAlertView
import SwiftyJSON


class TrackingDataViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var Date: [String] = []
    var Status: [String] = []
    var Location: [String] = []
    var JsonString:NSData? = nil
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let json = JSON(data: JsonString!)
        println(json)
        println(json[1]["status"].stringValue)
        
        for var index = 0; index < json.count; ++index {
            Status.append(json[index]["status"].stringValue)
            Location.append(json[index]["location"].stringValue)
            Date.append(json[index]["date"].stringValue)
        }
        
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return Status.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell",
                forIndexPath: indexPath) as! TrackingCell
            cell.date.text = Date[indexPath.row]
            cell.status.text = Status[indexPath.row]
            cell.location.text = Location[indexPath.row]
            
            return cell
    }
    
}