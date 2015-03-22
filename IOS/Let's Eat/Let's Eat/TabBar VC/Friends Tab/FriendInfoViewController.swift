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
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addFriendTapped() {
        
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let username: NSString = prefs.valueForKey("USERNAME") as NSString

        var post:NSString = "sender=\(username)&receiver=\(userNameField.text!)"
        
        NSLog("PostData: %@",post);
        
        var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/add_friend/")!
        
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
                
                if(status == "succes")
                {
                    NSLog("ADD SUCCESS");
                    
                    
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
