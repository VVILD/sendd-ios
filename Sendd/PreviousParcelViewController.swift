
import UIKit

class PreviousParcelViewController: UITabBarController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad viewDidLoad")
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.setupSwipeGestureRecognizers(cycleThroughTabs: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("viewDidAppear viewDidAppear")
    }
    
}
