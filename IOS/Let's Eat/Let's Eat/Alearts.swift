//
//  Errors.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 17.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//


import UIKit

class Alearts {
    
    func getSuccesError(jsonData: NSDictionary, vc: UIViewController){
        var error_msg:NSString
        
        if jsonData["message"] as? NSString != nil {
            error_msg = jsonData["message"] as NSString
        } else {
            error_msg = "Unknown Error"
        }
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign in Failed!"
        alertView.message = error_msg
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func getStatusCodeError(vc: UIViewController){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign in Failed!"
        alertView.message = "Connection Failed"
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func getUrlDataError(reponseError: NSError?, vc: UIViewController){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign in Failed!"
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
            message = jsonData["message"] as NSString
        } else {
            message = "You logout successfuly"
        }
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Perfect!"
        alertView.message = message
        alertView.delegate = vc
        alertView.addButtonWithTitle("OK")
        alertView.show()
        
    }


    
}