//
//  TimeCell.swift
//  I'm here!
//
//  Created by andres eddy ruiz on 7/19/19.
//  Copyright © 2019 andres eddy ruiz. All rights reserved.
//

import Foundation
import UIKit

class TimeCell: UITableViewCell
{
    @IBOutlet var timeCellLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        timeCellLabel.adjustsFontForContentSizeCategory = true
    }
}
