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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = friend["name"]
        surnameField.text = friend["surname"]
        userNameField.text = friend["username"]
        emailField.text = friend["email"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
