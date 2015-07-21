import UIKit

class PageItemController1: UIViewController {
    
    var itemIndex: Int = 0
    var imageName: String = "" {
        
        didSet {
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    var imagetitle: String = "" {
        
        didSet {
            if let imageTitle1 = contentTitle {
                imageTitle1.text = imagetitle
            }
        }
    }
    var imageDescription: String = "" {
        
        didSet {
            if let imageDescription1 = ContentDescription {
                imageDescription1.text = imageDescription
            }
        }
    }
    var senddButton: Bool = true {
        
        didSet {
            if let skipButton1 = skipButton {
                skipButton1.hidden = senddButton
            }
        }
    }
    
    @IBAction func onStartSendding(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject( false, forKey: "firstTimeUser")
        NSUserDefaults.standardUserDefaults().setObject( false, forKey: "LoggedIn")
        NSUserDefaults.standardUserDefaults().setObject( "0", forKey: "OrderID")
        NSUserDefaults.standardUserDefaults().setObject( "", forKey: "Code")
        NSUserDefaults.standardUserDefaults().setObject( false, forKey: "IsDataSynced")

     }
    
    @IBOutlet var ContentDescription: UILabel!
    @IBOutlet var contentTitle: UILabel!
    @IBOutlet var contentImageView: UIImageView?
    @IBOutlet var skipButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName)
        contentTitle!.text = imagetitle
        ContentDescription!.text = imageDescription
        skipButton.hidden = senddButton
    }
}
