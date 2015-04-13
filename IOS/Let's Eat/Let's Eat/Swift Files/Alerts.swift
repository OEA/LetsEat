//
//  Errors.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 17.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//


import UIKit

class Alerts {

    func getSuccesError(jsonData: NSDictionary, str: NSString, vc: UIViewController){
        var error_msg:NSString
        
        if jsonData["message"] as? NSString != nil {
            error_msg = jsonData["message"] as! NSString
        } else {
            error_msg = "Unknown Error"
        }
        var alertView:UIAlertView = UIAlertView()
        alertView.title = str as String
        alertView.message = error_msg as String
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func getStatusCodeError(str: NSString, vc: UIViewController){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = str as String
        alertView.message = "Connection Failed"
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func getUrlDataError(reponseError: NSError?, str: NSString, vc: UIViewController){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = str as String
        alertView.message = "Connection Failure"
        if let error = reponseError {
            alertView.message = (error.localizedDescription)
        }
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func loginError(vc: UIViewController){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign in Failed!"
        alertView.message = "Your username or password is incorrect"
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
        
    }
    
    func getSuccesLogoutAleart(jsonData: NSDictionary, vc: UIViewController){
        var message:NSString
        if jsonData["message"] as? NSString != nil {
            message = jsonData["message"] as! NSString
        } else {
            message = "You logout successfuly"
        }
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Perfect!"
        alertView.message = message as String
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
        
    }
    
    func emptyFieldError(str: NSString, vc: UIViewController){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = str as String
        alertView.message = "Please fill empty fields"
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func confirmError(str: NSString, vc: UIViewController){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = str as String
        alertView.message = "Passwords doesn't Match!"
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func unValidEmailError(str: NSString, vc: UIViewController){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = str as String
        alertView.message = "E-mail is not valid! \nPlease check your e-mail."
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func unValidPasswordError(str: NSString, vc: UIViewController){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = str as String
        alertView.message = "Your password needs minimum 6 characters and at least one upper case character, one lower case character and one numeric character"
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }




    
}