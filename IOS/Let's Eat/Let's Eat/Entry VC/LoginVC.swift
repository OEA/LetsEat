//
//  LoginVC.swift
//  login
//
//  Created by VidalHARA on 1.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var saveSwitch: UISwitch!
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var checkImage: UIButton!
    var bgSetter: BackgroundSetter!
    
    override func viewWillAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let switchBool: Bool = userDefaults.objectForKey("saveSwitch") as? Bool{
            saveSwitch.on = switchBool
        }
        
        if let username: AnyObject = userDefaults.valueForKey("savedUsername") {
            textUsername.text = username as NSString
            textPassword.text = userDefaults.valueForKey("savedPass") as NSString
        }
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        bgSetter = BackgroundSetter(viewControler: self)
        //bgSetter.getBackgroundView()
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
    
    @IBAction func nextKey(sender: UITextField) {
        if sender == textUsername{
            textPassword.becomeFirstResponder()
        }else {
            loginTapped()
            self.view.endEditing(true)
        }
    }
    
    @IBAction func minValidPass(sender: UITextField) {
        var str: NSString = sender.text
        
        if (str.length >= 6 ){
            checkImage.hidden = false
        }else{
            checkImage.hidden = true
        }
    }
    @IBAction func loginTapped() {
        var username:NSString = textUsername.text
        var password:NSString = textPassword.text
        self.view.endEditing(true)
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
           /* let userDefaults = NSUserDefaults.standardUserDefaults()
            if let defaultItems = userDefaults.arrayForKey("userInfoList") {
                let existentUser = (defaultItems.filter{ (($0["username"]) as String) == username })
                if existentUser.count == 1 {
                    let user = existentUser[0] as [String: NSString]
                    if let savedPassword = user["password"] {
                        if password == savedPassword as NSString {
                            userDefaults.setObject(user, forKey: "userInfo")
                            userDefaults.setObject(username, forKey: "USERNAME")
                            userDefaults.setInteger(1, forKey: "ISLOGGEDIN")
                            if saveSwitch.on == true{
                                userDefaults.setObject(username, forKey: "savedUsername")
                                userDefaults.setObject(password, forKey: "savedPass")
                            }
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }else {
                            loginError()
                        }
                    }else {
                        loginError()
                    }
                }else {
                    loginError()
                }
            }else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Please Sign-Up!"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }*/
            
            
            var post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/login/")!
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String( postData.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            if ( urlData != nil ) {
                let res = response as NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    println("Response ==>  \(responseData)");
                    
                    var error: NSError?
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
                    
                    
                    let status:NSString = jsonData.valueForKey("status") as NSString
                    
                    //[jsonData[@"success"] integerValue];
                    
                    println("Success: " + status)
                    
                    if(status == "success")
                    {
                        NSLog("Login SUCCESS");
                        
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        let userInfo: AnyObject? = jsonData.valueForKey("container")
                        prefs.setObject(userInfo, forKey: "userInfo")
                        prefs.synchronize()
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        if saveSwitch.on == true{
                            userDefaults.setObject(username, forKey: "savedUsername")
                            userDefaults.setObject(password, forKey: "savedPass")
                        }
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = error_msg
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signUpSegue"{
            let signUpVC = segue.destinationViewController as SignupVC
            signUpVC.view.backgroundColor = self.view.backgroundColor
        }
    }
    
    @IBAction func switchTapped() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if saveSwitch.on == false {
            userDefaults.removeObjectForKey("savedUsername")
            userDefaults.removeObjectForKey("savedPass")
            textPassword.text = ""
            textUsername.text = ""
        }
        userDefaults.setObject(saveSwitch.on, forKey: "saveSwitch")
    }
    
    func loginError(){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign in Failed!"
        alertView.message = "Your username or password is incorrect"
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
