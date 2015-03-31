//
//  ViewController.swift
//  login
//
//  Created by VidalHARA on 1.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SideBarDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {



    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var sideBar:SideBar = SideBar()
    let apiMethod = ApiMethods()
    let alert = Alerts()
    var searchedList = []
    var olustur = false
    
    @IBOutlet weak var naviItem: UINavigationItem!
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var searched = false
        var jsonData: NSDictionary!
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {() -> Void in
            if (searchBar.text != nil && searchBar.text != "") {
                var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/search/\(searchBar.text)")!
                
                var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                
                var reponseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
                
                if ( urlData != nil ) {
                    let res = response as NSHTTPURLResponse!;
                    
                    NSLog("Response code: %ld", res.statusCode);
                    
                    if (res.statusCode >= 200 && res.statusCode < 300){
                        
                        var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                        
                        NSLog("Response ==> %@", responseData);
                        
                        var error: NSError?
                        jsonData = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
                        
                        let status:NSString = jsonData.valueForKey("status") as NSString
                        
                        //[jsonData[@"success"] integerValue];
                        
                        println("Status: " + status)
                        
                        if(status == "success")
                        {
                            NSLog("Search SUCCESS");
                            searched = true
                            println(jsonData)
                        }
                    }
                }

            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if searched == true {
                    self.searchedList = jsonData["users"] as NSArray
                    self.tabelView.reloadData()
                }else{
                    self.searchedList = []
                    self.tabelView.reloadData()
                }
            })
        })
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        /*if json != nil && searchBar.text != ""{
            // name filter
            self.entries = self.baseEntries.filter{ (($0["from"]["name"].asString) as String!).rangeOfString(searchBar.text) != nil }
            //body filter
            let bodyFilter = self.baseEntries.filter{ (($0["body"].asString) as String!).rangeOfString(searchBar.text) != nil }
            entries = entries + bodyFilter
            self.deneme.reloadData()
        }else if searchBar.text == "" {
            self.entries = self.baseEntries
            self.deneme.reloadData()
        }*/
    }
    func sendReqests(friend: NSString, username: NSString){

        apiMethod.addFriend("http://127.0.0.1:8000/api/add_friend/", receiver: friend, vc: self, errorText: "Add Friend Failed!", sender: username)
        apiMethod.addFriend("http://127.0.0.1:8000/api/accept_friend/", receiver: friend, vc: self, errorText: "Accept Friend Failed!", sender: username)
    }
    
    func setSignUp(name: NSString, surname: NSString, email: NSString, password: NSString, username: NSString){
        
        var post:NSString = "name=\(name)&surname=\(surname)&email=\(email)&password=\(password)&username=\(username)"
        
        NSLog("PostData: %@",post);
        
        var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/register/")!
        
        var request = apiMethod.getRequest(url, post: post)
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        if ( urlData != nil ) {
            let res = response as NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                let jsonData = apiMethod.getJsonData(urlData!)
                
                
                let success:NSString = jsonData.valueForKey("status") as NSString
                
                //[jsonData[@"success"] integerValue];
                
                NSLog("Success: %ld", success);
                
                if(success == "success")
                {
                    NSLog("Sign Up SUCCESS");
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    
                } else {
                    alert.getSuccesError(jsonData, str: "Sign up Failed!", vc: self)
                }
                
            } else {
                alert.getStatusCodeError("Sign up Failed!", vc: self)
            }
        }  else {
            alert.getUrlDataError(reponseError, str: "Sign up Failed!", vc: self)
        }
    
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if searchedList.count > 0 {
            return searchedList.count
        }
        return 3
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as UITableViewCell
        let userNameLabel = cell.viewWithTag(1) as UILabel
        if searchedList.count > 0 {
            userNameLabel.text = searchedList[indexPath.item]["username"] as? NSString
        }
        
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
        if olustur {
            setSignUp("vidal", surname: "hara", email: "ab@ab.ab", password: "Vidal1", username: "vidal1")
            setSignUp("burak", surname: "atalay", email: "abc@ab.ab", password: "Vidal1", username: "burak1")
            setSignUp("hasan", surname: "sozer", email: "abcd@ab.ab", password: "Vidal1", username: "hasan1")
            setSignUp("hakan", surname: "uyumaz", email: "abcde@ab.ab", password: "Vidal1", username: "hakan1")
            sendReqests("hasan1", username: "vidal1")
            sendReqests("hakan1", username: "vidal1")
            sendReqests("burak1", username: "vidal1")
            olustur = false
        }
                
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

