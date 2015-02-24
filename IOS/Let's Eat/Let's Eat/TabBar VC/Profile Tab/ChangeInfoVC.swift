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
        newUser["username"] = usernameField.text
        newUser["email"] = emailField.text
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let defaultItems = userDefaults.arrayForKey("userInfoList") {
            for index in 0...defaultItems.count-1 {
                let savedUser = defaultItems[index] as [String: NSString]
                if let uname = savedUser["username"] {
                    if uname == userDefaults.stringForKey("USERNAME")! {
                        var savedList = defaultItems
                        savedList.removeAtIndex(index)
                        savedList.append(newUser)
                        userDefaults.setObject(savedList, forKey: "userInfoList")
                        if userImageView.image != nil {
                            //save image to server
                        }
                        userDefaults.setObject(usernameField.text, forKey: "USERNAME")
                        userDefaults.setObject(newUser, forKey: "userInfo")
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }
            }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

