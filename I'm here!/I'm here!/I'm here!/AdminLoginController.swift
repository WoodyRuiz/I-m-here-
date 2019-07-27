//
//  AdminLoginController.swift
//  I'm here!
//
//  Created by andres eddy ruiz on 7/19/19.
//  Copyright © 2019 andres eddy ruiz. All rights reserved.
//

import Foundation
import UIKit

class AdminLoginController: UIViewController
{
    
    @IBOutlet var pinText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBAction func go(_ sender: Any)
    {
        if emailText.text! == "Admin@admin.com" && Int(pinText.text!) == AccountList.sharedInstance.List[0].pin
        {
            performSegue(withIdentifier: "TimeSheetController", sender: self)
        }
        else
        {
            let alert = UIAlertController(title: "Invalid", message: "Incorrect credentials", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
}
