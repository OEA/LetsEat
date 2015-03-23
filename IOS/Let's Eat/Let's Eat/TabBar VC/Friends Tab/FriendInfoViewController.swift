//
//  FirendInfoViewController.swift
//  Let's Eat
//
//  Created by Vidal Hara on 19.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class FriendInfoViewController: UIViewController {

    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var surnameField: UILabel!
    @IBOutlet weak var userNameField: UILabel!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var friend: [String: NSString]!
    var findFriendChosen = false
    var isRequestView = false
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var acceptFriendButton: UIButton!
    @IBOutlet weak var rejectFriendButton: UIButton!
    
    
    let alert = Alerts()
    let apiMethod = ApiMethods()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = friend["name"]
        surnameField.text = friend["surname"]
        userNameField.text = friend["username"]
        emailField.text = friend["email"]
        if findFriendChosen == true{
            addFriendButton.hidden = false
        }else{
            addFriendButton.hidden = true
        }
        if isRequestView == true {
            acceptFriendButton.hidden = false
            rejectFriendButton.hidden = false
        }else{
            acceptFriendButton.hidden = true
            rejectFriendButton.hidden = true
        }
    }

    override func viewDidDisappear(animated: Bool) {
        findFriendChosen = false
        isRequestView = false
    }
    
    @IBAction func addFriendTapped() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let username: NSString = userDefaults.valueForKey("USERNAME") as NSString
        
        apiMethod.addFriend("http://127.0.0.1:8000/api/add_friend/", receiver: userNameField.text!, vc: self, errorText: "Add Friend Failed!", sender: username)
    }

    @IBAction func requestChoice(sender: UIButton) {
        if sender.titleLabel?.text == "Accept Friend" {
            acceptFriend()
        }else{
            rejectFriend()
        }
    }
    
    func acceptFriend(){
       apiMethod.acceptFriend(userNameField.text!, vc: self)
    }
    
    func rejectFriend(){
        apiMethod.rejectFriend(userNameField.text!, vc: self)
    }
}
