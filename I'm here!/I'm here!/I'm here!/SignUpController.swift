//
//  SignUpController.swift
//  I'm here!
//
//  Created by andres eddy ruiz on 7/17/19.
//  Copyright © 2019 andres eddy ruiz. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreData

class SignUpController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet var firstName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var pin: UITextField!
    @IBOutlet var confirmPin: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func Create(_ sender: Any)
    {
        if(hasEmptyField())
        {
            let alert = UIAlertController(title: "Form incomplete", message: "Please fill all fields", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        else if(noPic())
        {
            let alert = UIAlertController(title: "Picture required", message: "Use the camera button to take a picture", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        else if(AccountList.sharedInstance.emailExists(email: email.text!))
        {
            let alert = UIAlertController(title: email.text! + " already exists", message: "Please use another email", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)

        }
            
//        else if(!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: pin.text!)))
//        {
//            let alert = UIAlertController(title: "Invalid", message: "Pin must be numeric", preferredStyle: .alert)
//            
//            alert.addAction(UIAlertAction(title: "Understood", style: .default, handler: nil))
//            
//            self.present(alert, animated: true)
//        }
//        else if(AccountList.sharedInstance.pinExists(pin: Int(pin.text!)!))
//        {
//            let alert = UIAlertController(title: "Please use another pin", message: "Pin must be unique from other users", preferredStyle: .alert)
//            
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            
//            self.present(alert, animated: true)
//        }
//        else if(pin.text != confirmPin.text)
//        {
//            let alert = UIAlertController(title: "Pin does not match", message: "Enter the same pin in both fields", preferredStyle: .alert)
//            
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            
//            self.present(alert, animated: true)
//        }
            
        //Create the account and add it to the list
        else
        {
            
            var newPin = AccountList.sharedInstance.generatePin()
            var new = Account.init(firstName: firstName.text!, lastName: lastName.text!, email: email.text!, pin: newPin, clockedIn: false, timeSheet: [""], pic: imageView.image!)
            AccountList.sharedInstance.add(account: new)
            
            AccountList.sharedInstance.addToCore(account: new)
                        
            
            
            let alert = UIAlertController(title: "Welcome", message: "Your pin is " + String(newPin) + "\n Please write it down", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any])
    {
        // Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Put that image on the screen in the image view
        imageView.image = image
        // Take image picker off the screen -
        // you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePicture(_ sender: Any)
    {
        let imagePicker = UIImagePickerController()
        // If the device has a camera, take a picture; otherwise,
        // just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePicker.sourceType = .camera
        }
        else
        {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func hasEmptyField() -> Bool
    {
        if(firstName.text?.isEmpty)!
        {
            return true
        }
        else if(lastName.text?.isEmpty)!
        {
            return true
        }
        else if(email.text?.isEmpty)!
        {
            return true
        }
            
//        else if(pin.text?.isEmpty)!
//        {
//            return true
//        }
//        else if(confirmPin.text?.isEmpty)!
//        {
//            return true
//        }
        return false
    }
    
    func noPic() -> Bool
    {
        if(imageView.image == nil)
        {
            return true
        }
        return false
    }
    
}
