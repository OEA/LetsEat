//
//  GroupTableViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 6.04.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {
    
    var member1 = ["name":"burak", "surname": "atalay", "email": "abc@ab.ab", "password": "Vidal1", "username": "burak1"]
    var member2 = ["name":"hasan", "surname": "sozer", "email": "abcd@ab.ab", "password": "Vidal1", "username": "hasan1"]
    var members = [[String:AnyObject]]()
    var group: [String: AnyObject] = ["name":"testGroup"]
    
    
    
    
    var participants = [String: Bool]()
    var groupList = [[String:AnyObject]]()
    let apiMethods = ApiMethods()
    @IBOutlet var groupsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        members.append(member1)
        members.append(member2)
        group.updateValue(members, forKey: "members")
        groupList.append(group)
        groupsTable.reloadData()
        
        //apiMethods.getGroup(self)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return groupList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("ownedGroupCell") as! UITableViewCell
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let name = groupList[indexPath.item]["name"] as! String
        nameLabel.text = name
        let numLabel = cell.viewWithTag(2) as! UILabel
        let members = groupList[indexPath.item]["members"] as! [[String:AnyObject]]
        let num = members.count
        if num == 1 {
            numLabel.text = "One Friend"
        }else{
            numLabel.text = "\(num) Friends"
        }
        return cell
    }
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if sender is UITableViewCell{
            let gVC = segue.destinationViewController as! GroupViewController
            if let item = groupsTable.indexPathForSelectedRow()?.item {
                gVC.groupData = groupList[item]
            }
        }
    }

}
