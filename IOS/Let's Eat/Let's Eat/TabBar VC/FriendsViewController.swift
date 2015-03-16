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
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }

    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findFriend.titleLabel?.textColor = UIColor.blackColor()
        friendList.layer.borderColor = UIColor(red: 0, green: 122.0/255, blue: 1, alpha: 1).CGColor
        findFriend.layer.borderColor = UIColor(red: 127.0/255, green: 127.0/255, blue: 127.0/255, alpha: 1).CGColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as UITableViewCell
        
        return cell
    }
    @IBAction func listChoice(sender: UIButton) {
        if sender.titleLabel?.text == "Friend List"{
            sender.backgroundColor = UIColor(red: 0, green: 122.0/255, blue: 1, alpha: 1)
            sender.titleLabel?.textColor = UIColor.whiteColor()
            findFriend.backgroundColor = UIColor.whiteColor()
            findFriend.titleLabel?.textColor = UIColor.blackColor()
        }else {
            sender.backgroundColor = UIColor(red: 127.0/255, green: 127.0/255, blue: 127.0/255, alpha: 1)
            friendList.backgroundColor = UIColor.whiteColor()
            friendList.titleLabel?.textColor = UIColor.blackColor()
        }
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
