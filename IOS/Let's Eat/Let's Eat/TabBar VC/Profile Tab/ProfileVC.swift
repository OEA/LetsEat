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
  
    @IBAction func logoutTapped() {
        apiMethod.requestLogout(self)
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
