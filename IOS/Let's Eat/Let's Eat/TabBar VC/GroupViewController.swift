//
//  GroupViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 11.05.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchedList = []
    var friends = [] as [[String: AnyObject]]
    var addedFriendsNum = 0;
    let apiMethod = ApiMethods()
    var groupData: [String:AnyObject]!
    
    
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var groupNameLabel: UITextField!
    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.returnKeyType = UIReturnKeyType.Done
        searchBar.enablesReturnKeyAutomatically = false
        if let groupName = groupData["name"] as? String {
            self.navigationItem.title = groupName
        }
        var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let friendList: [[String: AnyObject]] = groupData["members"] as? [[String: AnyObject]]{
            friends = friendList
            searchedList = friends
            for friend in friends{
                let friendUserName = friend["username"] as! String
            }
            addedFriendsNum = friendList.count
            setParticipantLabel()
        }
    }
    
    func setParticipantLabel(){
        if addedFriendsNum == 1{
            participantLabel.text = "One Friend"
        }else {
            participantLabel.text = "\(addedFriendsNum) Friends"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        searchBar.text = ""
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {() -> Void in
            if (searchBar.text != nil && searchBar.text != "") {
                var list = [AnyObject]()
                for user in self.friends{
                    let name = user["name"] as! String
                    let surname = user["surname"] as! String
                    let username = user["username"] as! String
                    var b1 = name.rangeOfString(searchBar.text) != nil
                    var b2 = surname.rangeOfString(searchBar.text) != nil
                    var b3 = username.rangeOfString(searchBar.text) != nil
                    if  b1 || b2 || b3{
                        list.append(user)
                    }
                    self.searchedList = list
                }
            }else if self.searchBar.text == ""{
                self.searchedList = self.friends
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tabelView.reloadData()
            })
            
        })
    }
    
    func setFriendList(cell: UITableViewCell, indexPath: NSIndexPath){
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let name = searchedList[indexPath.item]["name"] as! String
        let surname = searchedList[indexPath.item]["surname"] as! String
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = searchedList[indexPath.item]["username"] as? String
        nameLabel.text = name + " " + surname
    }
    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tabelView.cellForRowAtIndexPath(indexPath){
            tabelView.reloadData()
        }
        
    }*/
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if searchedList.count > 0 {
            return searchedList.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("addFriendToGroupCell") as! UITableViewCell
        
        if searchedList.count > 0 {
            setFriendList(cell, indexPath: indexPath)
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is UITableViewCell{
            let friendInfoVC = segue.destinationViewController as! FriendInfoViewController
            let friendNum = tabelView.indexPathForSelectedRow()?.item
            friendInfoVC.friend = searchedList[friendNum!] as! [String: NSString]
            friendInfoVC.findFriendChosen = false
        }else if sender is UIBarButtonItem {
            let createEventVC = segue.destinationViewController as! CreateEventViewController
            var participants = [String: Bool]()
            for friend in friends{
                participants.updateValue(true, forKey: friend["username"] as! String)
            }
            createEventVC.participants = participants
        }
    }
    
    
}
