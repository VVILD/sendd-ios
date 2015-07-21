import UIKit

class CustomerSupportViewController: UIViewController {
    
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
    
}
