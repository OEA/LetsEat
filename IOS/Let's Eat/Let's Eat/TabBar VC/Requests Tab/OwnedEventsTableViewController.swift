//
//  OwnedEventsTableViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 30.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit


class OwnedEventsTableViewController: UITableViewController {

    var ownedEventList = [[String: AnyObject]]()
    let apiMethod = ApiMethods()
    var dateSetter = DateSetter()
    
    @IBOutlet var eventTBV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        apiMethod.getOwnedEvent(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ownedEventCell", forIndexPath: indexPath) as UITableViewCell
        if ownedEventList.count > 0{
            let event = ownedEventList[indexPath.item] as [String: AnyObject]
            let locationLabel = cell.viewWithTag(1) as UILabel
            let dateLabel = cell.viewWithTag(2) as UILabel
            let restaurant = event["restaurant"] as String
            locationLabel.text = restaurant
            let date = event["time"] as String
            
            dateLabel.text = dateSetter.getDate(date)
            let dateText = "\(dateLabel.text!)"
            if let firstWordR = dateText.rangeOfString(" ")?.startIndex{
                let firstWord = dateText.substringToIndex(firstWordR)
                let a: NSString = "\(firstWord)" as NSString
                if firstWord == "Today" || firstWord == "Tomorrow"{
                    dateLabel.textColor = UIColor.redColor()
                }
            }
        }
        return cell
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
        return ownedEventList.count
    }


}
