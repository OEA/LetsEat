//
//  ChangeInfoVC.swift
//  login
//
//  Created by VidalHARA on 5.11.2014.
//  Copyright (c) 2014 MacBook Retina. All rights reserved.
//

import UIKit

class ChangeInfoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var passwordField: UITextField!
  
    var user: [String: NSString]!
    
    override func viewDidAppear(animated: Bool) {
        
        nameField.text = user["name"]
        surnameField.text = user["surname"]
        usernameField.text = user["username"]
        emailField.text = user["email"]
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {() -> Void in
                //load image from server
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //userImageView.image = userImage
            })
        })
    }
    
    
    @IBAction func changeInfoTapped() {
        var newUser = user
        newUser["name"] = nameField.text
        newUser["surname"] = surnameField.text
        var password = passwordField.text
        var str = ""
        
        var post:NSString = "name=\(nameField.text)&surname=\(surnameField.text)&currentPassword=\(password)&newPassword=\(str)&newPassword2=\(str)"
        
        NSLog("PostData: %@",post);
        
        var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/profile/\(usernameField.text)/edit/")!
        
        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        var postLength:NSString = String( postData.length )
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        if ( urlData != nil ) {
            let res = response as NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                NSLog("Response ==> %@", responseData);
                
                var error: NSError?
                
                let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
                
                
                let success:NSString = jsonData.valueForKey("status") as NSString
                
                //[jsonData[@"success"] integerValue];
                
                println("Status: \(success)")
                
                if(success == "success")
                {
                    NSLog("Edit SUCCESS");
                    
                    var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    
                    userDefaults.setObject(newUser, forKey: "userInfo")
                    self.navigationController?.popViewControllerAnimated(true)
                    
                    
                } else {
                    var error_msg:NSString
                    
                    if jsonData["message"] as? NSString != nil {
                        error_msg = jsonData["message"] as NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Changing Failed!"
                    alertView.message = error_msg
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    
                }
                
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Changing Failed!"
                alertView.message = "Connection Failed"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }  else {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Changing Failed!"
            alertView.message = "Connection Failure"
            if let error = reponseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    @IBAction func editTapped() {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        userImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextKey(sender: UITextField) {
        if sender == nameField{
            surnameField.becomeFirstResponder()
        }else if(sender == surnameField){
            usernameField.becomeFirstResponder()
        }else if(sender == usernameField){
            emailField.becomeFirstResponder()
        }else {
            self.view.endEditing(true)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameField.text = user["name"]
        surnameField.text = user["surname"]
        usernameField.text = user["username"]
        emailField.text = user["email"]
    }
    
}

