//
//  FriendRequestsTableViewController.swift
//  Let's Eat
//
//  Created by Vidal Hara on 22.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class RequestsTableViewController: UITableViewController {
    
    var friendRequestList = []
    var eventReqList = []
    
    let alert = Alerts()
    let apiMethod = ApiMethods()


    @IBOutlet var friendReqtTV: UITableView!
    

    override func viewWillAppear(animated: Bool) {
        friendRequestList = []
        eventReqList = []
        getFriendRequests()
        //apiMethod.getOwnedEvent(self)
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if friendRequestList.count > 0 && eventReqList.count > 0{
            return 2
        }else if friendRequestList.count > 0 || eventReqList.count > 0 {
            return 1
        }
        return 0
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if friendRequestList.count > 0 && eventReqList.count > 0{
            if section == 0 {
                return "Event Requests"
            }else {
                return "Friend Requests"
            }
        }else if friendRequestList.count > 0 {
            return "Friend Requests"
        }else if eventReqList.count > 0 {
            return "Event Requests"
        }
        return ""
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if friendRequestList.count > 0 && eventReqList.count > 0{
            if section == 0 {
                return eventReqList.count
            }else {
                return friendRequestList.count
            }
        }else if friendRequestList.count > 0 {
            return friendRequestList.count
        }else if eventReqList.count > 0 {
            return eventReqList.count
        }
        return 0
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("friendRequestCell", forIndexPath: indexPath) as UITableViewCell
        if friendRequestList.count > 0 && eventReqList.count > 0{
            if indexPath.section == 0{
                cell = tableView.dequeueReusableCellWithIdentifier("eventRequestCell", forIndexPath: indexPath) as UITableViewCell
            }else{
                setFriendList(cell, indexPath: indexPath)
            }
        }else if eventReqList.count > 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("eventRequestCell", forIndexPath: indexPath) as UITableViewCell
            
        }else if friendRequestList.count > 0 {
            setFriendList(cell, indexPath: indexPath)
        }
        return cell
    }
    
    func setFriendList(cell: UITableViewCell, indexPath: NSIndexPath){
        let nameLabel = cell.viewWithTag(1) as UILabel
        let name = friendRequestList[indexPath.item]["name"] as NSString
        let surname = friendRequestList[indexPath.item]["surname"] as NSString
        let userNameLabel = cell.viewWithTag(2) as UILabel
        userNameLabel.text = friendRequestList[indexPath.item]["username"] as? NSString
        nameLabel.text = name + " " + surname
        let check = cell.viewWithTag(3) as UIButton
        let cross = cell.viewWithTag(4) as UIButton
        check.addTarget(self, action: "requestFriendChoice:", forControlEvents: UIControlEvents.TouchUpInside)
        cross.addTarget(self, action: "requestFriendChoice:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setEventList(cell: UITableViewCell, indexPath: NSIndexPath){
        let ownerField = cell.viewWithTag(1) as UILabel
        let owner = eventReqList[indexPath.item]["owner"] as [String: AnyObject]
        ownerField.text = owner["username"] as NSString
        let eventLocName = cell.viewWithTag(2) as UILabel
        let restaurant = eventReqList[indexPath.item]["restaurant"] as [String: NSString]
        eventLocName.text = restaurant["name"]
        let timeField = cell.viewWithTag(5) as UILabel
        let time = eventReqList[indexPath.item]["time"] as NSString
        timeField.text = time
        let check = cell.viewWithTag(3) as UIButton
        let cross = cell.viewWithTag(4) as UIButton
        check.addTarget(self, action: "requestEventChoice:", forControlEvents: UIControlEvents.TouchUpInside)
        cross.addTarget(self, action: "requestEventChoice:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func requestFriendChoice(sender: UIButton) {
        let cell = sender.superview?.superview as UITableViewCell
        if let index = friendReqtTV.indexPathForCell(cell)?.item{
            let username = friendRequestList[index]["username"] as NSString
            if sender.tag == 3 {
                apiMethod.acceptFriend(username, vc: self)
            }else if sender.tag == 4 {
                apiMethod.rejectFriend(username, vc: self)
            }
        }
        
        
    }
    func requestEventChoice(sender: UIButton){
        let cell = sender.superview?.superview as UITableViewCell
        if let index = friendReqtTV.indexPathForCell(cell)?.item{
            let event = eventReqList[index] as [String: AnyObject]
            if sender.tag == 3 {
                apiMethod.acceptEvent(event, vc: self)
            }else if sender.tag == 4 {
                apiMethod.rejectEvent(event, vc: self)
            }
        }
    }
    
    func getFriendRequests(){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let username: NSString = prefs.valueForKey("USERNAME") as NSString
        
        var post:NSString = "username=\(username)"
        
        NSLog("PostData: %@",post);
        
        var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/get_friend_requests/")!
        
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
                    
                    friendRequestList = jsonData["senders"] as NSArray
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
            friendInfoVC.friend = friendRequestList[friendNum!] as [String: NSString]
            friendInfoVC.isRequestView = true
        }
    }


}
