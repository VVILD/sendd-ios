//
//  AddressTableCell.swift
//  Sendd
//
//  Created by harsh karanpuria on 6/23/15.
//  Copyright (c) 2015 CrazymindTechnology. All rights reserved.
//

import UIKit

class AddressTableCell: UITableViewCell {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var Address: UILabel!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
