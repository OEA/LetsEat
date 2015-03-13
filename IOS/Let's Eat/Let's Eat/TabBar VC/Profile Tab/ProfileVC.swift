//
//  ProfileVC.swift
//  login
//
//  Created by VidalHARA on 5.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var surnameField: UILabel!
    @IBOutlet weak var userNameField: UILabel!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    var user: [String: NSString]!
    
    override func viewWillDisappear(animated: Bool) {
         self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let userInfo = userDefaults.objectForKey("userInfo") as? [String: NSString]{
            user = userInfo
            nameField.text = user["name"]
            surnameField.text = user["surname"]
            userNameField.text = user["username"]
            emailField.text = user["email"]
        }

    }
  
    @IBAction func logoutTapped() {
        var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/logout/")!

        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
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
            
                let status:NSString = jsonData.valueForKey("status") as NSString
                
                //[jsonData[@"success"] integerValue];
                
                println("Status: " + status)
                
                if(status == "success")
                {
                    NSLog("Logout SUCCESS");
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setInteger(0, forKey: "ISLOGGEDIN")
                    userDefaults.removeObjectForKey("USERNAME")
                    
                    var message:NSString
                    if jsonData["message"] as? NSString != nil {
                        message = jsonData["message"] as NSString
                    } else {
                        message = "Logout Successfuly"
                    }
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = message
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
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

        //self.navigationController?.popToRootViewControllerAnimated(true)
        //self.performSegueWithIdentifier("goToLogin", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if sender is UIButton{
        if sender as UIButton == infoButton{
            let infoVC = segue.destinationViewController as ChangeInfoVC
            if user != nil {
                infoVC.user = user
            }
        }else if sender as UIButton == changePasswordButton{
            let passwordVC = segue.destinationViewController as ChangePasswordVC
            if user != nil {
                passwordVC.user = user
            }
        }
      }
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
