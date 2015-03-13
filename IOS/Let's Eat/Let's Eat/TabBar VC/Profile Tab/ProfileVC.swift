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
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(0, forKey: "ISLOGGEDIN")
        userDefaults.removeObjectForKey("USERNAME")
        self.navigationController?.popToRootViewControllerAnimated(true)
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
