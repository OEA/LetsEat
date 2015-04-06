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
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.returnKeyType = UIReturnKeyType.Done
        searchBar.enablesReturnKeyAutomatically = false

        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        /*var searched = false
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
        }*/
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("addFriendToGroupCell") as UITableViewCell
        return cell
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
