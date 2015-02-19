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
    @IBOutlet weak var infoButton: UIButton!
    var user: [String: NSString]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let defaultItems = userDefaults.arrayForKey("userInfoList") {
            let existentUser = (defaultItems.filter{ (($0["username"]) as String) == userDefaults.stringForKey("USERNAME") })
            if existentUser.count == 1 {
                user = existentUser[0] as [String: NSString]

                nameField.text = user["name"]
                surnameField.text = user["surname"]
                userNameField.text = user["username"]
                emailField.text = user["email"]
            }
        }
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      /*if sender is UIButton{
        if sender as UIButton == infoButton{
            let infoVC = segue.destinationViewController as ChangeInfoVC
            infoVC.ozyegin = ozyegin
            if user != nil {
                infoVC.user = user
                let a = sender as UIButton
                
                println(a.backgroundColor)
            }
        }else {
          let passwordVC = segue.destinationViewController as ChangePasswordVC
            if user != nil {
                passwordVC.user = user
            }
        }
      }*/
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
