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
    
    let alert = Alerts()
    let apiMethod = ApiMethods()
    
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
        
        var request = apiMethod.getRequest(url, post: post)
        
        
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        if ( urlData != nil ) {
            let res = response as NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                let jsonData = apiMethod.getJsonData(urlData!)
                
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
                    alert.getSuccesError(jsonData, str: "Changing Failed!", vc: self)
                }
                
            } else {
                alert.getStatusCodeError("Changing Failed!", vc: self)
            }
        }  else {
            alert.getUrlDataError(reponseError, str: "Changing Failed!", vc: self)
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

