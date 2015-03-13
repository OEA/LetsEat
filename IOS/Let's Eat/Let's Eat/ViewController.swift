//
//  ViewController.swift
//  login
//
//  Created by VidalHARA on 1.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let prefs = NSUserDefaults.standardUserDefaults()
        let isLoggedIn = prefs.integerForKey("ISLOGGEDIN")
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
            
        } else {
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as NSString
            if let defaultItems = prefs.arrayForKey("userInfoList") {
                let existentUser = (defaultItems.filter{ (($0["username"]) as String) == prefs.stringForKey("USERNAME") })
                if existentUser.count == 1 {
                    prefs.setObject(existentUser[0], forKey: "USER")
                    
                }
            }
            self.reloadInputViews()
            self.performSegueWithIdentifier("goto_Main", sender: self)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    private func update(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("json")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      /*if segue.identifier == "goToCourseList"{
        let tbc = segue.destinationViewController as UITabBarController
        let tabViewArray = tbc.customizableViewControllers!
        let courseListVC = tabViewArray[0] as CourseListViewController
            courseListVC.homeViewController = self
        courseListVC.ozyegin = ozyegin
        let schedulerVC = tabViewArray[1] as ChoosedCourseListViewController
        schedulerVC.ozyegin = ozyegin
      }*/
    }
  
}

