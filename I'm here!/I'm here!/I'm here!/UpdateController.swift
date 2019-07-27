//
//  UpdateController.swift
//  I'm here!
//
//  Created by andres eddy ruiz on 7/19/19.
//  Copyright © 2019 andres eddy ruiz. All rights reserved.
//

import Foundation
import UIKit

class UpdateController: UIViewController, UINavigationControllerDelegate
{
    @IBOutlet var emailText: UITextField!
    
    @IBAction func getNewPin(_ sender: Any)
    {
        if(AccountList.sharedInstance.emailExists(email: emailText.text!))
        {
            var newPin: Int = AccountList.sharedInstance.generatePin()
            
            AccountList.sharedInstance.updatePin(email: emailText.text!, newPin: newPin)
            
            let alert = UIAlertController(title: "Pin Updated", message: String(newPin) + "\nPlease write it down", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Invalid", message: "Email not linked with an existing account", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
}
