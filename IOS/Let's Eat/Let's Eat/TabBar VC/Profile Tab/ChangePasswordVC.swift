//
//  ChangePasswordVC.swift
//  login
//
//  Created by VidalHARA on 5.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    
    @IBOutlet weak var passwordCheck: UIButton!
    @IBOutlet weak var passwordConfirmCheck: UIButton!
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    var user: [String: NSString]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
    
    @IBAction func nextKey(sender: UITextField) {
        if sender == oldPasswordField{
            passwordField.becomeFirstResponder()
        }else if(sender == passwordField){
            passwordConfirmField.becomeFirstResponder()
        }else {
            self.view.endEditing(true)
        }
    }
   

    @IBAction func passwordImageCheck() {
        if isPasswordValid(){
            passwordConfirmCheck.hidden = false
            passwordCheck.hidden = false
        }else{
            changePasswordButton.backgroundColor = UIColor (red: 0.77184, green: 0, blue: 0, alpha: 1.0)
            passwordConfirmCheck.hidden = true
            passwordCheck.hidden = true
        }
    }
    @IBAction func changePasswordTapped(sender: UIButton) {
        self.view.endEditing(true)
        
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if let savedPassword = user["password"] {
                if oldPasswordField.text == savedPassword {
                    if isPasswordValid(){
                    
                        user["password"] = passwordField.text
                        if let defaultItems = userDefaults.arrayForKey("userInfoList") {
                            for index in 0...defaultItems.count-1 {
                                let savedUser = defaultItems[index] as [String: NSString]
                                if let uname = savedUser["username"] {
                                    if uname == userDefaults.stringForKey("USERNAME")! {
                                        var savedList = defaultItems
                                        savedList.removeAtIndex(index)
                                        savedList.append(user)
                                        userDefaults.setObject(savedList, forKey: "userInfoList")
                                        sender.backgroundColor = UIColor (red: 0, green: 0.501961, blue: 0, alpha: 1.0)
                                        passwordChangedAlert()
                                        break
                                    }
                                }
                            }
                        }
                        self.navigationController?.popViewControllerAnimated(true)
                    }else{
                        var passwordConfirmTxt: NSString = passwordConfirmField.text
                        var passwordTxt: NSString = passwordField.text
                        if passwordTxt == "" || passwordConfirmTxt == "" || oldPasswordField.text == ""{
                            emptyFieldError()
                        }else if passwordTxt != passwordConfirmTxt {
                            confirmError()
                        }else{
                            unValidPasswordError()
                        }
                    }
                }
            }
        
    }

    func isPasswordValid() -> Bool {
        var passwordConfirmTxt: NSString = passwordConfirmField.text
        if (passwordConfirmTxt.length >= 6 ){
            var passwordTxt: NSString = passwordField.text
            if(passwordTxt == passwordConfirmTxt){
                if (passwordTxt.rangeOfCharacterFromSet(NSCharacterSet.uppercaseLetterCharacterSet()).location != NSNotFound && passwordTxt.rangeOfCharacterFromSet(NSCharacterSet.lowercaseLetterCharacterSet()).location != NSNotFound && passwordTxt.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet()).location != NSNotFound){
                    return true
                }
            }
        }
        return false
    }
    func emptyFieldError(){
      var alertView:UIAlertView = UIAlertView()
      alertView.title = "Change Password Failed!"
      alertView.message = "Please fill in all fields!"
      alertView.delegate = self
      alertView.addButtonWithTitle("OK")
      alertView.show()
    }
  
    func confirmError(){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Change Password Failed!"
        alertView.message = "Passwords does not match!"
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func unValidPasswordError(){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Change Password Failed!"
        alertView.message = "Your password needs minimum 6 characters and at least one upper case character, one lower case character and one numeric character"
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func passwordChangedAlert(){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Password Successfully Changed"
        alertView.message = nil
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
}
