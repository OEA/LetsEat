//
//  LoginVC.swift
//  login
//
//  Created by VidalHARA on 1.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var saveSwitch: UISwitch!
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var checkImage: UIButton!
    var bgSetter: BackgroundSetter!
    

    @IBOutlet weak var fbButtonView: FBSDKLoginButton!
    let alert = Alerts()
    let apiMethod = ApiMethods()
    
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
        bgSetter.getBackgroundView()
        
    }
    
    override func viewDidLoad() {
        if (FBSDKAccessToken.currentAccessToken() != nil){
            //loginWithFaceB()
            //returnUserData()
        }else{
            fbButtonView.readPermissions = ["public_profile", "email"]
        }
    }
    
    func loginButton(fbButtonView: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil){
            // Process error
        }else if result.isCancelled {
            // Handle cancellations
        }else {
            if result.grantedPermissions.containsObject("email"){
                self.returnUserData()
                loginWithFaceB()
            }
        }
    }
    
    func loginButtonDidLogOut(fbButtonView: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnUserData(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil){
                // Process error
                println("Error: \(error)")
            }else{
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("first_name") as NSString
                let userSurname : NSString = result.valueForKey("last_name") as NSString
                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as NSString
                println("User Email is: \(userEmail)")
                
                var username = "\(userName).\(userSurname)"
                var num:Int = random() % 10000;
                username = "\(username)\(num)"
                
                let userInfo = ["name": result.valueForKey("first_name")!, "surname": result.valueForKey("last_name")!, "username": username, "email": result.valueForKey("email")!]
                println("Test: \(userInfo)")
                /*var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

                prefs.setObject(userInfo["username"], forKey: "USERNAME")
                prefs.setInteger(1, forKey: "ISLOGGEDIN")
                prefs.setObject(userInfo, forKey: "userInfo")
                self.dismissViewControllerAnimated(true, completion: nil)*/
            }
        })
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
        
        if (str.length >= 1 ){
            checkImage.hidden = false
        }else{
            checkImage.hidden = true
        }
    }
    
    func getUserInfo() -> [String: AnyObject]{
        var userInfo: [String: AnyObject]!
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil){
                // Process error
                println("Error: \(error)")
            }else{
                let userName : NSString = result.valueForKey("first_name") as NSString
                let userSurname : NSString = result.valueForKey("last_name") as NSString
                let userEmail : NSString = result.valueForKey("email") as NSString
                let id: NSString = result.valueForKey("id") as NSString
                
                /*var username = "\(userName).\(userSurname)"
                var num:Int = random() % 10000;
                username = "\(username)\(num)"*/
                
                /*var password = 0
                while(password < 1000000000){
                    password = random() % 10000000000;
                }
                let passText = "\(password)"*/
                
                userInfo = ["name": userName, "surname": userSurname, "email": userEmail, "id": id]
            }
        })
        if userInfo == nil{
            return ["Error": true]
        }
        return userInfo
    }
    
    func loginWithFaceB(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil){
                // Process error
                println("Error: \(error)")
            }else{
                var id:NSString = result.valueForKey("id") as NSString
                
                
                var post:NSString = "facebook_id=\(id)"
                
                NSLog("PostData: %@",post);
                
                var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/login_with_facebook/")!
                
                var request = self.apiMethod.getRequest(url, post: post)
                
                var responseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
                if ( urlData != nil ) {
                    let res = response as NSHTTPURLResponse!;
                    
                    NSLog("Response code: %ld", res.statusCode);
                    
                    if (res.statusCode >= 200 && res.statusCode < 300)
                    {
                        
                        let jsonData:NSDictionary = self.apiMethod.getJsonData(urlData!)
                        
                        let status:NSString = jsonData.valueForKey("status") as NSString
                        
                        //[jsonData[@"success"] integerValue];
                        
                        println("Success: " + status)
                        
                        if(status == "success")
                        {
                            NSLog("Login SUCCESS");
                            
                            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            
                            prefs.setInteger(1, forKey: "ISLOGGEDIN")
                            let userInfo: [String: AnyObject] = jsonData.valueForKey("user") as [String: AnyObject]
                            prefs.setObject(userInfo, forKey: "userInfo")
                            prefs.setObject(userInfo["username"], forKey: "USERNAME")
                            prefs.synchronize()
                            println("Test: \(userInfo)")
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        } else {
                            self.registerWithFaceB()
                        }
                    } else {
                        self.alert.getStatusCodeError("Loginin Failed!", vc:self)
                    }
                } else {
                    self.alert.getUrlDataError(responseError, str:"Login Failed!", vc: self)
                }
                
            }
        })
    

    }
    
    func registerWithFaceB(){
        println("Girdi-Login")
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil){
                // Process error
                println("Error: \(error)")
            }else{
                var name = result.valueForKey("first_name") as NSString
                var surname:NSString = result.valueForKey("last_name") as NSString
                if result.valueForKey("middle_name") != nil {
                    let middleName = result.valueForKey("middle_name") as NSString
                    name = "\(name) \(middleName)"
                }
                var email:NSString = result.valueForKey("email") as NSString
                var id:NSString = result.valueForKey("id") as NSString
                
                
                var post:NSString = "name=\(name)&surname=\(surname)&email=\(email)&facebook_id=\(id)"
                
                NSLog("PostData: %@",post);
                
                var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/register_with_facebook/")!
                
                var request = self.apiMethod.getRequest(url, post: post)
                
                var responseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
                if ( urlData != nil ) {
                    let res = response as NSHTTPURLResponse!;
                    
                    NSLog("Response code: %ld", res.statusCode);
                    
                    if (res.statusCode >= 200 && res.statusCode < 300)
                    {
                        
                        let jsonData:NSDictionary = self.apiMethod.getJsonData(urlData!)
                        
                        let status:NSString = jsonData.valueForKey("status") as NSString
                        
                        //[jsonData[@"success"] integerValue];
                        
                        println("Success: " + status)
                        
                        if(status == "success")
                        {
                            NSLog("Signin SUCCESS")
                            self.loginWithFaceB()
                            
                        } else {
                            self.alert.getSuccesError(jsonData, str:"Sign in Failed!", vc: self)
                        }
                    } else {
                        self.alert.getStatusCodeError("Sign in Failed!", vc:self)
                    }
                } else {
                    self.alert.getUrlDataError(responseError, str:"Sign in Failed!", vc: self)
                }

            }
        })
    }
    
    @IBAction func loginTapped() {
        var username:NSString = textUsername.text
        var password:NSString = textPassword.text
        self.view.endEditing(true)
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            alert.emptyFieldError("Sign in Failed!", vc: self)
        } else {
    
            var post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/login/")!
            
            var request = apiMethod.getRequest(url, post: post)
            
            var responseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
            if ( urlData != nil ) {
                let res = response as NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    
                    let jsonData:NSDictionary = apiMethod.getJsonData(urlData!)
                    
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
                        if saveSwitch.on == true{
                            prefs.setObject(username, forKey: "savedUsername")
                            prefs.setObject(password, forKey: "savedPass")
                        }
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        alert.getSuccesError(jsonData, str:"Sign in Failed!", vc: self)
                    }
                } else {
                    alert.getStatusCodeError("Sign in Failed!", vc:self)
                }
            } else {
                alert.getUrlDataError(responseError, str:"Sign in Failed!", vc: self)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
