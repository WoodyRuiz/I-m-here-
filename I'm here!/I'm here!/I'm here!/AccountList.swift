//
//  AccountList.swift
//  I'm here!
//
//  Created by andres eddy ruiz on 7/15/19.
//  Copyright © 2019 andres eddy ruiz. All rights reserved.
//
import UIKit
import CoreData

struct Account
{
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var pin: Int
    var clockedIn: Bool
    var timeSheet: [String]
    var pic: UIImage
}

class AccountList
{
    static let sharedInstance = AccountList()
    
    var List : [Account] = [Account(firstName: "Admin", lastName: "Sudo", email: "Admin@admin.com", pin: 1010, clockedIn: false, timeSheet: [""], pic: UIImage())]
    
    var timeSheet: [String] = [""]
    
    init()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        request.returnsObjectsAsFaults = false
        
        let timeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeSheet")
        timeRequest.returnsObjectsAsFaults = false
        
        do{//initialize data from database into timesheet array
        let timeResults = try context.fetch(timeRequest)
        for time in timeResults as! [NSManagedObject]
            {
                self.timeSheet.append(time.value(forKey: "logins") as! String)
            }
        }
            
        catch
            {
                print("time init failed")
            }
        
        do{// initialize and store accounts from database into accounts array
            let results = try context.fetch(request)
            for data in results as! [NSManagedObject]
            {
                let firstname = data.value(forKey: "firstName") as! String
                let lastname = data.value(forKey: "lastName") as! String
                let pin = data.value(forKey: "pin") as! Int
                let email = data.value(forKey: "email") as! String
                let clockedin = data.value(forKey: "clockedIn") as! Bool
                let timesheet = data.value(forKey: "timeSheet") as! [String]
                let pic = data.value(forKey: "pic") as! UIImage
                
                let pulledAccounts = Account(firstName: firstname, lastName: lastname, email: email, pin: pin, clockedIn: clockedin, timeSheet: timesheet, pic: pic)
                
                self.add(account: pulledAccounts)
            }
        } catch {
            print("failed init")
        }

        
    }
    
    func add(account: Account)
    {
        List.append(account)
        
        
    }
    
    func addToCore(account: Account)// add acounts to core data
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let NewUser = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        
        NewUser.setValue(account.firstName, forKey: "firstName")
        NewUser.setValue(account.lastName, forKey: "lastName")
        NewUser.setValue(account.email, forKey: "email")
        NewUser.setValue(account.pin, forKey: "pin")
        NewUser.setValue(false, forKey: "clockedIn")
        NewUser.setValue([""], forKey: "timeSheet")
        NewUser.setValue(account.pic, forKey: "pic")
        
        do{
            try context.save()
        }
        catch
        {
            print("context couldt not save addCore")
        }
    }
    
    //This will only be called once the account has been verified to exist
    func isClockedIn(pin: Int) -> Bool
    {
        for i in List
        {
            if(pin == i.pin)
            {
                if(i.clockedIn == false)
                {
                    return false
                }
                else
                {
                    return true
                }
            }
        }
        return false
    }
    
    //Checks that a given account exists via pin
    func pinExists(pin: Int) -> Bool
    {
        for i in List
        {
            if pin == i.pin
            {
                return true
            }
        }
        
        return false
    }
    
    //Checks if an email exists
    func emailExists(email: String) -> Bool
    {
        for i in List
        {
            if(email == i.email)
            {
                return true
            }
        }
        return false
    }
    
    //Returns the current time, formatted
    func getTime() -> String
    {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        var currTime = formatter.string(from: currentDateTime)
        
        return currTime
    }
    
    func updatePin(email: String, newPin: Int)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        request.returnsObjectsAsFaults = false
        
        
        for index in List.indices
        {
            if email == List[index].email
            {
                do//insert new pin into database
                {
                    let results = try context.fetch(request)
                    for data in results as! [NSManagedObject]
                    {
                        if email == data.value(forKey: "email") as! String
                        {
                            data.setValue(newPin, forKey: "pin")
                        }
                
                    }
                }
                catch
                {
                    print("failed update pin")
                }
                List[index].pin = newPin
            }
        }
        
        do
        {
            try context.save()
        }
        catch{
            print("context did not save update")
        }
    }
    
    func generatePin() -> Int
    {
        var newPin: Int = 1010
        while(AccountList.sharedInstance.pinExists(pin: newPin))
        {
            newPin = Int(arc4random_uniform(UInt32(10000-0)) + UInt32(0))
        }
        return newPin
    }
    
    //Clocks in/out an account
    func punch(pin: Int, time: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        request.returnsObjectsAsFaults = false
        
        let timeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeSheet")
        timeRequest.returnsObjectsAsFaults = false
        
        do{// stores clock in for account within the employee entity
            let results = try context.fetch(request)
            for data in results as! [NSManagedObject]
            {
                
                let ModelPin = data.value(forKey: "pin") as! Int
                if (ModelPin == pin)
                {
                    let punchType = data.value(forKey: "clockedIn") as! Bool
                    if punchType == true {
                        data.setValue(false, forKey: "clockedIn")
                        var timeArray = data.value(forKey: "timeSheet") as! [String]
                        timeArray.append("Clocked out: " + time)
                        data.setValue(timeArray, forKey: "timeSheet")
                    }
                    else {
                        data.setValue(true, forKey: "clockedIn")
                        var timeArray = data.value(forKey: "timeSheet") as! [String]
                        timeArray.append("Clocked in: " + time)
                        data.setValue(timeArray, forKey: "timeSheet")
                    }
                    
                }
            }
        } catch {
            print("failed")
        }
        
        
        do{//updates new punches to timesheet entity
            let timeResults = try context.fetch(timeRequest)
            for index in List.indices
            {
                if pin == List[index].pin
                {
                    if(List[index].clockedIn == true)
                    {
                        let newTime = NSEntityDescription.insertNewObject(forEntityName: "TimeSheet", into: context)
                        newTime.setValue(List[index].firstName + " " + List[index].lastName + "\tClocked out:\t" + time, forKey: "logins")
                        
                    }
                    else
                    {
                        let newTime = NSEntityDescription.insertNewObject(forEntityName: "TimeSheet", into: context)
                    newTime.setValue(List[index].firstName + " " + List[index].lastName + "\tClocked in:\t" + time, forKey: "logins")
                        
                    }
                }
            }
        }
        catch
        {
            print("time result failed")
        }
        
        
        for index in List.indices
        {
            if pin == List[index].pin
            {
                if(List[index].clockedIn == true)
                {
                    List[index].clockedIn = false
                    List[index].timeSheet.append("Clocked out: " + time)
                    timeSheet.append(List[index].firstName + " " + List[index].lastName + "\tClocked out:\t" + time)
                    
                    
                }
                else
                {
                    List[index].clockedIn = true
                    List[index].timeSheet.append("Clocked in: " + time)
                    timeSheet.append(List[index].firstName + " " + List[index].lastName + "\tClocked in:\t" + time)
                }
            }
        }
        do
        {
            try context.save()
        }
        catch
        {
            print("context did not save")
        }
    }
}
