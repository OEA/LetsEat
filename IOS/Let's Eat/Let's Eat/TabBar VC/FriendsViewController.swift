//
//  FriendsViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 9.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var findFriend: UIButton!
    @IBOutlet weak var friendList: UIButton!
    @IBOutlet weak var tabelView: UITableView!
    
    var friends = []
    var searchedList = []
    var findFriendChosen = false
    
    let alert = Alerts()
    let apiMethod = ApiMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findFriend.titleLabel?.textColor = UIColor.blackColor()
        friendList.layer.borderColor = UIColor(red: 0, green: 122.0/255, blue: 1, alpha: 1).CGColor
        findFriend.layer.borderColor = UIColor(red: 127.0/255, green: 127.0/255, blue: 127.0/255, alpha: 1).CGColor
        // Do any additional setup after loading the view.
        
        getFriendList()
    }
    
    func getFriendList(){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let username: NSString = prefs.valueForKey("USERNAME") as NSString
        
        var post:NSString = "username=\(username)"
        
        NSLog("PostData: %@",post);
        
        var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/get_friends/")!
        
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
                    friends = jsonData["friends"] as NSArray
                    searchedList = friends
                    println(jsonData)
                    
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

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var searched = false
        var jsonData: NSDictionary!
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {() -> Void in
            if (searchBar.text != nil && searchBar.text != "" && self.findFriendChosen) {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let username: NSString = userDefaults.valueForKey("USERNAME") as NSString
                
                var post:NSString = "username=\(username)"
                NSLog(post)
                var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/search/\(searchBar.text)/")!
                
                var request = self.apiMethod.getRequest(url, post: post)

                
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
                    if jsonData["users"] != nil {
                        self.searchedList = jsonData["users"] as NSArray
                        self.tabelView.reloadData()
                    }
                }else{
                    self.searchedList = []
                    self.tabelView.reloadData()
                }
            })
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if searchedList.count > 0 {
            return searchedList.count
        }
        return 0
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as UITableViewCell
        if searchedList.count > 0 {
            
                let nameLabel = cell.viewWithTag(1) as UILabel
                let name = searchedList[indexPath.item]["name"] as NSString
                let surname = searchedList[indexPath.item]["surname"] as NSString
                let userNameLabel = cell.viewWithTag(2) as UILabel
                userNameLabel.text = searchedList[indexPath.item]["username"] as? NSString
                nameLabel.text = name + " " + surname
            
        }
        
        return cell
    }
    @IBAction func listChoice(sender: UIButton) {
        self.searchedList = []

        if sender.titleLabel?.text == "Friend List"{
            sender.backgroundColor = UIColor(red: 0, green: 122.0/255, blue: 1, alpha: 1)
            sender.titleLabel?.textColor = UIColor.whiteColor()
            findFriend.backgroundColor = UIColor.whiteColor()
            findFriend.titleLabel?.textColor = UIColor.blackColor()
            searchedList = friends
            findFriendChosen = false
        }else {
            sender.backgroundColor = UIColor(red: 127.0/255, green: 127.0/255, blue: 127.0/255, alpha: 1)
            friendList.backgroundColor = UIColor.whiteColor()
            friendList.titleLabel?.textColor = UIColor.blackColor()
            findFriendChosen = true
        }
        self.tabelView.reloadData()
    }
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is UITableViewCell{
        
        let friendInfoVC = segue.destinationViewController as FriendInfoViewController
            let friendNum = tabelView.indexPathForSelectedRow()?.item
            friendInfoVC.friend = searchedList[friendNum!] as [String: NSString]
            if findFriendChosen {
                friendInfoVC.findFriendChosen = findFriendChosen
            }
        }
    }

}
