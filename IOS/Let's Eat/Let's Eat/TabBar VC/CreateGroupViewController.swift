//
//  CreateGroupViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 6.04.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var searchedList = []
    var friends = [] as [[String: AnyObject]]
    var addedFriends: [String: Bool]!
    var groupID: Int!
    var addedFriendsNum = 0;
    var image = UIImage()
    let apiMethod = ApiMethods()
    
    
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var groupNameLabel: UITextField!
    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addedFriends = [String: Bool]()
        searchBar.returnKeyType = UIReturnKeyType.Done
        searchBar.enablesReturnKeyAutomatically = false
        var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let friendList: [[String: AnyObject]] = userDefaults.valueForKey("Friends") as? [[String: AnyObject]]{
            friends = friendList
            searchedList = friends
            for index in 0...friends.count-1{
                let friend = friends[index]
                let friendUserName = friend["username"] as String
                if addedFriends[friendUserName] == nil{
                    addedFriends.updateValue(false, forKey: friend["username"] as String)
                }
            }
        }
        if let image2 = UIImage(named: "check"){
            image = imageResize(image2)
        }
        // Do any additional setup after loading the view.
    }
    
    func setParticipantLabel(){
        if addedFriendsNum == 1{
            participantLabel.text = "One Friend"
        }else if addedFriendsNum > 1 {
            participantLabel.text = "\(addedFriendsNum) Friends"
        }else {
            participantLabel.text = "Add Friends"
        }
    }
    
    func imageResize (imageObj:UIImage)-> UIImage{
        var sizeChange = CGSizeMake(50, 50)
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    override func viewWillAppear(animated: Bool) {
        searchBar.text = ""
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
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
                    let name = user["name"] as String
                    let surname = user["surname"] as String
                    let username = user["username"] as String
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
        let nameLabel = cell.viewWithTag(1) as UILabel
        let name = searchedList[indexPath.item]["name"] as NSString
        let surname = searchedList[indexPath.item]["surname"] as NSString
        let userNameLabel = cell.viewWithTag(2) as UILabel
        userNameLabel.text = searchedList[indexPath.item]["username"] as? NSString
        nameLabel.text = name + " " + surname
        let cellCheck = cell.viewWithTag(4) as UIButton
        cellCheck.addTarget(self, action: "checkCheckbox:", forControlEvents: UIControlEvents.TouchUpInside)
        if (addedFriends[userNameLabel.text!] == true){
            cellCheck.backgroundColor = UIColor(patternImage: image)
        }else{
            cellCheck.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tabelView.cellForRowAtIndexPath(indexPath){
            setCheckBox(cell)
            tabelView.reloadData()
        }
        
    }
    
    func checkCheckbox (sender:UIButton!) {
        if let cell = sender.superview?.superview as? UITableViewCell{
            setCheckBox(cell)
            tabelView.reloadData()
        }
    }
    
    func setCheckBox(cell: UITableViewCell){
        let userNameLabel = cell.viewWithTag(2) as UILabel
        if (addedFriends[userNameLabel.text!] == true){
            addedFriends[userNameLabel.text!] = false
            addedFriendsNum--
        }else if (addedFriends[userNameLabel.text!] == false){
            addedFriends[userNameLabel.text!] = true
            addedFriendsNum++
        }
        setParticipantLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("addFriendToGroupCell") as UITableViewCell
        
        if searchedList.count > 0 {
            setFriendList(cell, indexPath: indexPath)
        }
        return cell
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        apiMethod.createGroup(groupNameLabel.text, vc: self)
        if groupID != nil{
            addFriends()
        }
    }
    
    func addFriends(){
        for friend in addedFriends{
            if friend.1{
                apiMethod.addGroupMember("", member: friend.0, vc: self, errorText: "", group_id: groupID)
            }
        }
    }
    
    func getFriendObject(friend: NSString) -> NSDictionary{
        for user in friends{
            if user["username"] as NSString == friend {
                return user as NSDictionary
            }
        }
        return ["Error": true]
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
