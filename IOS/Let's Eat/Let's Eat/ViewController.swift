//
//  ViewController.swift
//  login
//
//  Created by VidalHARA on 1.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SideBarDelegate {


    @IBOutlet weak var imageView: UIImageView!
    var sideBar:SideBar = SideBar()
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        if index == 0{
            performSegueWithIdentifier("goto_Main", sender: UITableViewCell())
        } else if index == 1{
            performSegueWithIdentifier("goto_Profile", sender: UITableViewCell())
        }
    }
    
    @IBAction func menuTapped(sender: UIBarButtonItem) {
        if sideBar.isSideBarOpen{
            sideBar.showSideBar(false)
        }else{
            sideBar.showSideBar(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sideBar = SideBar(sourceView: self.view, menuItems: ["Friend List", "Profile"])
        sideBar.delegate = self
    }

    override func viewWillDisappear(animated: Bool) {
        sideBar.showSideBar(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let prefs = NSUserDefaults.standardUserDefaults()
        let isLoggedIn = prefs.integerForKey("ISLOGGEDIN")
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            
        }

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
  
    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(0, forKey: "ISLOGGEDIN")
        userDefaults.removeObjectForKey("USERNAME")

        self.performSegueWithIdentifier("goto_login", sender: self)
    }

}

