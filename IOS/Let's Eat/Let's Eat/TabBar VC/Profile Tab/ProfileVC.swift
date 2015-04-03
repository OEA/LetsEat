//
//  ProfileVC.swift
//  login
//
//  Created by VidalHARA on 5.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, FBSDKLoginButtonDelegate  {
    
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var surnameField: UILabel!
    @IBOutlet weak var userNameField: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var fLogOutView: FBSDKLoginButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    var user: [String: NSString]!
    
    let alert = Alerts()
    let apiMethod = ApiMethods()
    
    override func viewWillAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let userInfo = userDefaults.objectForKey("userInfo") as? [String: NSString]{
            user = userInfo
            nameField.text = user["name"]
            surnameField.text = user["surname"]
            userNameField.text = user["username"]
            emailField.text = user["email"]
            
        }
    }
    
    override func viewDidLoad() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let user = userDefaults.objectForKey("userInfo") as [String: NSString]
        if (FBSDKAccessToken.currentAccessToken() != nil){
            changePasswordButton.hidden = true
            logOutButton.hidden = true
            fLogOutView.hidden = false
        }
    }
    
    func loginButton(fLogOutView: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
    }
    
    func loginButtonDidLogOut(fLogOutView: FBSDKLoginButton!) {
        println("User Logged Out")
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(0, forKey: "ISLOGGEDIN")
        userDefaults.removeObjectForKey("userInfo")
        userDefaults.removeObjectForKey("Friends")
        userDefaults.removeObjectForKey("USERNAME")
        self.tabBarController?.selectedIndex = 0
    }

  
    @IBAction func logoutTapped() {
        apiMethod.requestLogout(self)
        self.tabBarController?.selectedIndex = 0
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

}
