//
//  ViewController.swift
//  login
//
//  Created by VidalHARA on 1.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SideBarDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var imageView: UIImageView!
    var sideBar:SideBar = SideBar()
    let apiMethod = ApiMethods()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as UITableViewCell
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let label = cell?.viewWithTag(10) as UILabel
        label.text = "1"
        tableView.reloadData()
    }
    
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        if index == 0{
            performSegueWithIdentifier("goto_Main", sender: UITableViewCell())
        } else if index == 1 {
            performSegueWithIdentifier("goto_Profile", sender: UITableViewCell())
        }else if index == 2 {
            apiMethod.requestLogout(self)
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
        sideBar = SideBar(sourceView: self.view, menuItems: ["Friend List", "Profile", "Logout"])
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
  
    

}

