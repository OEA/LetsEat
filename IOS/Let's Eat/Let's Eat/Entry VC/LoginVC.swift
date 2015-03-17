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
    
    let aleart = Alearts()
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
    
            var post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/login/")!
            
            var request = apiMethod.getRequest(url, post: post)
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
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
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        if saveSwitch.on == true{
                            userDefaults.setObject(username, forKey: "savedUsername")
                            userDefaults.setObject(password, forKey: "savedPass")
                        }
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        aleart.getSuccesError(jsonData, vc: self)
                    }
                } else {
                    aleart.getStatusCodeError(self)
                }
            } else {
                aleart.getUrlDataError(reponseError, vc: self)
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
