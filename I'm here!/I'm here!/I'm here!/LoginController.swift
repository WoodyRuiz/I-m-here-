//
//  ViewController.swift
//  I'm here!
//
//  Created by andres eddy ruiz on 7/15/19.
//  Copyright © 2019 andres eddy ruiz. All rights reserved.
//

import UIKit
import Foundation

class LoginController: UIViewController
{
    @IBOutlet var textPin: UITextField!

    @IBAction func goButton(_ sender: UIButton)
    {
        if(textPin.text?.isEmpty)!
        {
            let alert = UIAlertController(title: "Empty", message: "Pin must be numeric", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        else if(CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: textPin.text!)))
        {
            if(AccountList.sharedInstance.pinExists(pin: Int(textPin.text!)!))
            {
                var time = AccountList.sharedInstance.getTime()
            
                //If they are clocked in then inform them of the time they are clokcing out and clock them out
                if(AccountList.sharedInstance.isClockedIn(pin: Int(textPin.text!)!))
                {
                    let alert = UIAlertController(title: textPin.text! + " clocked out", message: time, preferredStyle: .alert)
                
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                    self.present(alert, animated: true)
                
                    AccountList.sharedInstance.punch(pin: Int(textPin.text!)!, time: time)
                }
                else
                {
                    let alert = UIAlertController(title: textPin.text! + " clocked in", message: time, preferredStyle: .alert)
                
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                    self.present(alert, animated: true)
                
                    AccountList.sharedInstance.punch(pin: Int(textPin.text!)!, time: time)
                }
            }
            else
            {
                let alert = UIAlertController(title: textPin.text! + " is invalid", message: "Did not clock-in/out", preferredStyle: .alert)
            
                alert.addAction(UIAlertAction(title: "Understood", style: .default, handler: nil))
            
                self.present(alert, animated: true)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Invalid", message: "Pin must be numeric", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Understood", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

