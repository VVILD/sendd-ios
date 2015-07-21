//
//  PageItemController.swift
//  Paging_Swift
//
//  Created by Olga Dalton on 26/10/14.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {
    
    // MARK: - Variables
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

    
    @IBOutlet var ContentDescription: UILabel!
    @IBOutlet var contentTitle: UILabel!
    @IBOutlet var contentImageView: UIImageView?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName)
        contentTitle!.text = imagetitle
        ContentDescription!.text = imageDescription
    }
}
