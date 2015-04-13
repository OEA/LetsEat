//
//  EventViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 13.04.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    var event: [String: AnyObject]!
    var participants = [] as [[String: AnyObject]]

    @IBOutlet weak var participantsTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        let list = event["participants"] as! [[String: AnyObject]]
        if list.count > 0{
            participants = list
            participantsTV.reloadData()
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        /*if searchedList.count > 0 {
            return searchedList.count
        }*/
        return participants.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! UITableViewCell
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let name = participants[indexPath.item]["name"] as! String
        let surname = participants[indexPath.item]["surname"] as! String
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = participants[indexPath.item]["username"] as? String
        nameLabel.text = name + " " + surname
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is UINavigationItem {
            let button = sender as! UINavigationItem
            if button.title == "Comments" {
                let commentsVC = segue.destinationViewController as! CommentsViewController
                let comments: AnyObject? = event["comments"]
                commentsVC.comments = comments
            }
        }
    }

}
