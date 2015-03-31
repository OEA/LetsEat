//
//  AddParticipantViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 27.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class AddParticipantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var friends = [] as [[String: AnyObject]]
    var searchedList = []
    var addedFriends: [String: Bool]!
    var backUIVC: UIViewController!
    var image = UIImage()
    
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.returnKeyType = UIReturnKeyType.Done
        searchBar.enablesReturnKeyAutomatically = false
        
        //Sil bunları
        //friends = [["name": "test1", "surname": "test1", "username": "test1", "email": "test1"], ["name": "hello", "surname": "hello", "username": "hello", "email": "hello"]]
        //
        
        if let image2 = UIImage(named: "check"){
            image = imageResize(image2)
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let list = userDefaults.valueForKey("Friends") as? [[String: AnyObject]]{
            friends = list
                for index in 0...friends.count-1{
                    let friend = friends[index]
                    let friendUserName = friend["username"] as String
                    if addedFriends[friendUserName] == nil{
                        addedFriends.updateValue(false, forKey: friend["username"] as String)
                    }
                }
        }
        
        searchedList = friends
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var searched = false
            if (searchBar.text != nil && searchBar.text != "") {
                var list = [AnyObject]()
                for user in friends{
                    let name = user["name"] as String
                    let surname = user["surname"] as String
                    let username = user["username"] as String
                    var b1 = name.rangeOfString(searchBar.text) != nil
                    var b2 = surname.rangeOfString(searchBar.text) != nil
                    var b3 = username.rangeOfString(searchBar.text) != nil
                    if  b1 || b2 || b3{
                        list.append(user)
                    }
                }
                searchedList = list
                self.tabelView.reloadData()
            }else if searchBar.text == ""{
                searchedList = friends
                self.tabelView.reloadData()
            }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if searchedList.count > 0 {
            return searchedList.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("addFriendCell") as UITableViewCell
        if searchedList.count > 0 {
            
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
        return cell
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
        }else if (addedFriends[userNameLabel.text!] == false){
            addedFriends[userNameLabel.text!] = true
        }
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        if let backUI = backUIVC as? CreateEventViewController{
            var list = [String: Bool]()
            let keys = addedFriends.keys.array
            for userKey in keys{
                if addedFriends[userKey] == true {
                    list.updateValue(true, forKey: userKey)
                }
            }
            backUI.participants = list
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
