//
//  TimeSheetController.swift
//  I'm here!
//
//  Created by andres eddy ruiz on 7/19/19.
//  Copyright © 2019 andres eddy ruiz. All rights reserved.
//

import Foundation
import UIKit

class TimeSheetController: UITableViewController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell",
                                                 for: indexPath) as! TimeCell
    
        let time = AccountList.sharedInstance.timeSheet[indexPath.row]
        
        // Configure the cell with the Item
        cell.timeCellLabel.text = time
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        return AccountList.sharedInstance.timeSheet.count
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
