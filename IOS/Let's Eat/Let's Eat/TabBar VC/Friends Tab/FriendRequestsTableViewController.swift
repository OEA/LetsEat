//
//  FriendRequestsTableViewController.swift
//  Let's Eat
//
//  Created by Vidal Hara on 22.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class FriendRequestsTableViewController: UITableViewController {
    
    var requestList = []
    
    let alert = Alerts()
    let apiMethod = ApiMethods()


    @IBOutlet var friendReqtTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getFriendRequests()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return requestList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendRequestCell", forIndexPath: indexPath) as UITableViewCell
        if requestList.count > 0 {
                let nameLabel = cell.viewWithTag(1) as UILabel
                let name = requestList[indexPath.item]["name"] as NSString
                let surname = requestList[indexPath.item]["surname"] as NSString
                let userNameLabel = cell.viewWithTag(2) as UILabel
                userNameLabel.text = requestList[indexPath.item]["username"] as? NSString
                nameLabel.text = name + " " + surname
        }


        return cell
    }
    
    func getFriendRequests(){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let username: NSString = prefs.valueForKey("USERNAME") as NSString
        
        var post:NSString = "username=\(username)"
        
        NSLog("PostData: %@",post);
        
        var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/get_friend_requests/")!
        
        //      var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        var request = apiMethod.getRequest(url, post: post)
        
        var responseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
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
                    
                    println(jsonData)
                    
                    requestList = jsonData["senders"] as NSArray
                    friendReqtTV.reloadData()
                    
                    
                } else {
                    alert.getSuccesError(jsonData, str:"Sign in Failed!", vc: self)
                }
            } else {
                alert.getStatusCodeError("Sign in Failed!", vc:self)
            }
        } else {
            alert.getUrlDataError(responseError, str:"Sign in Failed!", vc: self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is UITableViewCell{
            
            let friendInfoVC = segue.destinationViewController as FriendInfoViewController
            let friendNum = friendReqtTV.indexPathForSelectedRow()?.item
            friendInfoVC.friend = requestList[friendNum!] as [String: NSString]
        }
    }


}
