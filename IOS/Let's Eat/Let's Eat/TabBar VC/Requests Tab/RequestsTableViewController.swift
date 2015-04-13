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
    var dateSetter = DateSetter()

    @IBOutlet var friendReqtTV: UITableView!
    

    override func viewWillAppear(animated: Bool) {
        friendRequestList = []
        eventReqList = []
        apiMethod.getUserRequests(self)
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
        //var cell = tableView.dequeueReusableCellWithIdentifier("friendRequestCell", forIndexPath: indexPath) as UITableViewCell
        if friendRequestList.count > 0 && eventReqList.count > 0{
            if indexPath.section == 0{
                var cell = tableView.dequeueReusableCellWithIdentifier("eventRequestCell", forIndexPath: indexPath) as! UITableViewCell
                setEventList(cell, indexPath: indexPath)
                return cell
            }else{
                var cell = tableView.dequeueReusableCellWithIdentifier("friendRequestCell", forIndexPath: indexPath) as! UITableViewCell
                setFriendList(cell, indexPath: indexPath)
                return cell
            }
        }else if eventReqList.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("eventRequestCell", forIndexPath: indexPath) as! UITableViewCell
            setEventList(cell, indexPath: indexPath)
            return cell
        }else if friendRequestList.count > 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("friendRequestCell", forIndexPath: indexPath) as! UITableViewCell
            setFriendList(cell, indexPath: indexPath)
            return cell
        }
        var cell = tableView.dequeueReusableCellWithIdentifier("friendRequestCell", forIndexPath: indexPath) as! UITableViewCell
        return cell
    }
    
    func setFriendList(cell: UITableViewCell, indexPath: NSIndexPath){
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let name = friendRequestList[indexPath.item]["name"] as! String
        let surname = friendRequestList[indexPath.item]["surname"] as! String
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = friendRequestList[indexPath.item]["username"] as? String
        nameLabel.text = name + " " + surname
        let check = cell.viewWithTag(3) as! UIButton
        let cross = cell.viewWithTag(4) as! UIButton
        check.addTarget(self, action: "requestFriendChoice:", forControlEvents: UIControlEvents.TouchUpInside)
        cross.addTarget(self, action: "requestFriendChoice:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setEventList(cell: UITableViewCell, indexPath: NSIndexPath){
        let ownerField = cell.viewWithTag(1) as! UILabel
        let owner = eventReqList[indexPath.item]["owner"] as! [String: AnyObject]
        ownerField.text = owner["username"] as? String
        
        let eventLocName = cell.viewWithTag(2) as! UILabel
        let restaurant = eventReqList[indexPath.item]["restaurant"] as! String
        eventLocName.text = restaurant
        
        let timeField = cell.viewWithTag(5) as! UILabel
        let time = eventReqList[indexPath.item]["time"] as! String
        timeField.text = dateSetter.getDate(time)
        
        let dateText = "\(timeField.text)"
        if let firstWordR = dateText.rangeOfString(" ")?.startIndex{
            let firstWord = dateText.substringToIndex(firstWordR)
            let a: NSString = "\(firstWord)" as NSString
            if firstWord == "Today" || firstWord == "Tomorrow"{
                timeField.textColor = UIColor.redColor()
            }
        }


        
        let check = cell.viewWithTag(3) as! UIButton
        let cross = cell.viewWithTag(4) as! UIButton
        check.addTarget(self, action: "requestEventChoice:", forControlEvents: UIControlEvents.TouchUpInside)
        cross.addTarget(self, action: "requestEventChoice:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func requestFriendChoice(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        if let index = friendReqtTV.indexPathForCell(cell)?.item{
            let username = friendRequestList[index]["username"] as! String
            if sender.tag == 3 {
                apiMethod.acceptFriend(username, vc: self)
            }else if sender.tag == 4 {
                apiMethod.rejectFriend(username, vc: self)
            }
        }
        
        
    }
    
    func requestEventChoice(sender: UIButton){
        let cell = sender.superview?.superview as! UITableViewCell
        if let index = friendReqtTV.indexPathForCell(cell)?.item{
            let event = eventReqList[index] as! [String: AnyObject]
            if sender.tag == 3 {
                apiMethod.acceptEvent(event["id"] as! Int, vc: self)
            }else if sender.tag == 4 {
                apiMethod.rejectEvent(event["id"] as! Int, vc: self)
            }
        }
        apiMethod.getUserRequests(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is UITableViewCell{
            if segue.destinationViewController is FriendInfoViewController{
                let friendInfoVC = segue.destinationViewController as! FriendInfoViewController
                let friendNum = friendReqtTV.indexPathForSelectedRow()?.item
                friendInfoVC.friend = friendRequestList[friendNum!] as! [String: NSString]
                friendInfoVC.isRequestView = true
            }
        }
    }


}
