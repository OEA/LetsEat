//
//  SigupVC.swift
//  login
//
//  Created by VidalHARA on 1.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var textSurname: UITextField!
    
    @IBOutlet weak var textUsername: UITextField!
    
    @IBOutlet weak var textEmail: UITextField!
    
    @IBOutlet weak var textPassword: UITextField!
    
    @IBOutlet weak var textConfirmPassword: UITextField!
    
    @IBOutlet weak var passwordCheck: UIButton!
    
    @IBOutlet weak var passwordConfirmCheck: UIButton!
    
    let apiMethod = ApiMethods()
    
    override func viewWillAppear(animated: Bool) {
        let bgSetter = BackgroundSetter(viewControler: self)
        bgSetter.getBackgroundView()
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
    
    @IBAction func nextKey(sender: UITextField) {
        if sender == textName{
            textSurname.becomeFirstResponder()
        }else if sender == textSurname{
            textUsername.becomeFirstResponder()
        }else if sender == textUsername{
            textEmail.becomeFirstResponder()
        }else if sender == textEmail{
            textPassword.becomeFirstResponder()
        }else if sender == textPassword{
            textConfirmPassword.becomeFirstResponder()
        }else {
            signupTapped()
            self.view.endEditing(true)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func scrollForEditing(sender: UITextField) {
        // If it is in landscape
        if sender == textPassword {
            scrollView.setContentOffset(CGPointMake(0, 20), animated: true)
            
        }
    }

    @IBAction func signupTapped() {
        self.view.endEditing(true)
        var name:NSString = textName.text as NSString
        var surname:NSString = textSurname.text as NSString
        var username:NSString = textUsername.text as NSString
        var email:NSString = textEmail.text as NSString
        var password:NSString = textPassword.text as NSString
        var confirm_password:NSString = textConfirmPassword.text as NSString
        
        if ( name.isEqualToString("") || surname.isEqualToString("") || username.isEqualToString("")  || password.isEqualToString("") || confirm_password.isEqualToString("") || email.isEqualToString("")) {
            
            emptyFieldError()
            
        }else if !isEmailValid(email){
            unValidEmailError()
        }else if password != confirm_password {
            confirmError()
        }else if !isPasswordValid() {
            
            unValidPasswordError()
            
        }else {
            
            var post:NSString = "name=\(name)&surname=\(surname)&email=\(email)&password=\(password)&username=\(username)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/register/")!
            
            var request = apiMethod.getRequest(url, post: post)
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
                    
                    
                    let success:NSString = jsonData.valueForKey("status") as NSString
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == "success")
                    {
                        NSLog("Sign Up SUCCESS");
                        
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["message"] as? NSString != nil {
                            error_msg = jsonData["message"] as NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }  else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }
    }
    
    
    
   
    @IBAction func passwordImageCheck() {
        if isPasswordValid() {
            passwordConfirmCheck.hidden = false
            passwordCheck.hidden = false
        }else{
            passwordConfirmCheck.hidden = true
            passwordCheck.hidden = true
        }
        
    }
    
    
    @IBAction func backToLogin() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func isPasswordValid() -> Bool {
        var passwordConfirmTxt: NSString = textConfirmPassword.text
        if (passwordConfirmTxt.length >= 6 ){
            var passwordTxt: NSString = textPassword.text
            if(passwordTxt == passwordConfirmTxt){
                if (passwordTxt.rangeOfCharacterFromSet(NSCharacterSet.uppercaseLetterCharacterSet()).location != NSNotFound && passwordTxt.rangeOfCharacterFromSet(NSCharacterSet.lowercaseLetterCharacterSet()).location != NSNotFound && passwordTxt.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet()).location != NSNotFound){
                    return true
                }
            }
        }
        return false
    }
    
    func isEmailValid(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        if let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx) {
            return emailTest.evaluateWithObject(email)
        }
        return false
    }
    
    func emptyFieldError(){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign Up Failed!"
        alertView.message = "Please fill empty fields"
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func confirmError(){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign Up Failed!"
        alertView.message = "Passwords doesn't Match!"
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func unValidEmailError(){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign Up Failed!"
        alertView.message = "E-mail is not valid! \nPlease check your e-mail."
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func unValidPasswordError(){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign Up Failed!"
        alertView.message = "Your password needs minimum 6 characters and at least one upper case character, one lower case character and one numeric character"
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func userError(){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign Up Failed!"
        alertView.message = "There is an user which has same username with you. Please change your username!"
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
