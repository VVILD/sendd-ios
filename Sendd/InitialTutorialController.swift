//
//  viewController1.swift
//  Sendd
//
//  Created by harsh karanpuria on 6/20/15.
//  Copyright © 2015 CrazymindTechnology. All rights reserved.
//
import UIKit

class TutorialViewController1: UIPageViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    private let contentImages = ["logo_circle_icon.png","camera_icon.png",
        "bike_icon.png",
        "packaging_icon.png",
        "relax_icon.png","logo_circle_icon.png"];
    
    private let contentTitle = [ "The most convenient way to sendd anything anywhere","Click a photo",
        "On demand pickup",
        "Free Packaging",
        "Sit back & relax","Get ready to Sendd"];
    private let contentDescription = ["<< Swipe to know how",
        "Click the photo of the item & set up the destination address. We sendd across the world !",
        "Sendd representative will be at your doorstep to pickup your parcel at your preferred time.",
        "Trained packing specialists will bring world class packing materials and assist in packaging to make sure your items reach safely.",
        "We will pick up your items, pack, and sendd them using the most cost effective & reliable shipping options.",""];
    private let visibility = [ true,true,true,true,true,false]
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            setViewControllers(startingViewControllers as! [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        setupPageControl()
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.blackColor()
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController1

        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController1
        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> PageItemController1? {
        
        if itemIndex < contentImages.count {
            let pageItemController1 = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController2") as!PageItemController1
            pageItemController1.itemIndex = itemIndex
            pageItemController1.imageName = contentImages[itemIndex]
            pageItemController1.imagetitle = contentTitle[itemIndex]
            pageItemController1.imageDescription = contentDescription[itemIndex]
            pageItemController1.senddButton = visibility[itemIndex]
            return pageItemController1
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
