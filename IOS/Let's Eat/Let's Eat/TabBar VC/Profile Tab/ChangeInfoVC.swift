//
//  ChangeInfoVC.swift
//  login
//
//  Created by VidalHARA on 5.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class ChangeInfoVC: UIViewController {
  
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
  
    var user: [String: NSString]!
    
    override func viewDidAppear(animated: Bool) {
        
        nameField.text = user["name"]
        surnameField.text = user["surname"]
        usernameField.text = user["username"]
        emailField.text = user["email"]
    }
    
    @IBAction func changeInfoTapped() {
        var newUser = user
        newUser["name"] = nameField.text
        newUser["surname"] = surnameField.text
        newUser["username"] = usernameField.text
        newUser["email"] = emailField.text
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let defaultItems = userDefaults.arrayForKey("userInfoList") {
            for index in 0...defaultItems.count-1 {
                let savedUser = defaultItems[index] as [String: NSString]
                if let uname = savedUser["username"] {
                    if uname == userDefaults.stringForKey("USERNAME")! {
                        var savedList = defaultItems
                        savedList.removeAtIndex(index)
                        savedList.append(newUser)
                        userDefaults.setObject(savedList, forKey: "userInfoList")
                        userDefaults.setObject(usernameField.text, forKey: "USERNAME")
                        userDefaults.setObject(newUser, forKey: "userInfo")
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }
            }
        }
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func nextKey(sender: UITextField) {
        if sender == nameField{
            surnameField.becomeFirstResponder()
        }else if(sender == surnameField){
            usernameField.becomeFirstResponder()
        }else if(sender == usernameField){
            emailField.becomeFirstResponder()
        }else {
            self.view.endEditing(true)
        }
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameField.text = user["name"]
        surnameField.text = user["surname"]
        usernameField.text = user["username"]
        emailField.text = user["email"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

