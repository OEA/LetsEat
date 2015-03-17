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
    let alert = Alerts()
    let apiMethod = ApiMethods()
    
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
        if isPasswordValid(){
            
            var name = user["name"]!
            var surname = user["surname"]!
            var username = user["username"]!
    
            var post:NSString = "name=\(name)&surname=\(surname)&currentPassword=\(oldPasswordField.text)&newPassword=\(passwordField.text)&newPassword2=\(passwordConfirmField.text)"
                        
            NSLog("PostData: %@",post);
                        
            var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/profile/\(username)/edit/")!
                        
            var request = apiMethod.getRequest(url, post: post)
            
            var reponseError: NSError?
            var response: NSURLResponse?
                        
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
                        
            if ( urlData != nil ) {
                let res = response as NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                            
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let jsonData = apiMethod.getJsonData(urlData!)
                    
                    let success:NSString = jsonData.valueForKey("status") as NSString
                                
                                //[jsonData[@"success"] integerValue];
                                
                    println("Status: \(success)")
                                
                    if(success == "success")
                    {
                        NSLog("Edit SUCCESS");
                                    

                        sender.backgroundColor = UIColor (red: 0, green: 0.501961, blue: 0, alpha: 1.0)
                                    passwordChangedAlert()
                                    
                        self.navigationController?.popViewControllerAnimated(true)
                                    
                                    
                    } else {
                        alert.getSuccesError(jsonData, str: "Changing Failed!", vc: self)
                    }
                    
                } else {
                    alert.getStatusCodeError("Changing Failed!", vc: self)
                }
            }  else {
                alert.getUrlDataError(reponseError, str: "Changing Failed!", vc: self)
            }
        }else{
            var passwordConfirmTxt: NSString = passwordConfirmField.text
            var passwordTxt: NSString = passwordField.text
            if passwordTxt == "" || passwordConfirmTxt == "" || oldPasswordField.text == ""{
                alert.emptyFieldError("Change Password Failed!", vc: self)
            }else if passwordTxt != passwordConfirmTxt {
                alert.confirmError("Change Password Failed!", vc: self)
            }else{
                alert.unValidPasswordError("Change Password Failed!", vc: self)
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
    
    func passwordChangedAlert(){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Password Successfully Changed"
        alertView.message = nil
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
}
