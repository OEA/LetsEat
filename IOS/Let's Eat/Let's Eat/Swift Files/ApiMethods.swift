//
//  ApiMethods.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 17.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class ApiMethods {
    let alert = Alerts()
    
    func getRequest(url: NSURL, post: NSString) -> NSMutableURLRequest{
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
            var postLength:NSString = String( postData.length )
        
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        
            return request
    }
    
    func getJsonData(urlData: NSData) -> NSDictionary{
        var responseData:NSString  = NSString(data:urlData, encoding:NSUTF8StringEncoding)!
        
        println("Response ==>  \(responseData)");
        
        var error: NSError?
        return NSJSONSerialization.JSONObjectWithData(urlData, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
    }
    
    func requestLogout(vc: UIViewController){
        var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/logout/")!
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        if ( urlData != nil ) {
            let res = response as NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            checkResponse(urlData!, res: res, vc: vc)
            
        } else {
            alert.getUrlDataError(reponseError, str:"Logout Failed!", vc: vc)
        }
        
    }
    
    func checkResponse(urlData: NSData, res: NSHTTPURLResponse, vc: UIViewController){
        if (res.statusCode >= 200 && res.statusCode < 300){
            
            var responseData:NSString  = NSString(data:urlData, encoding:NSUTF8StringEncoding)!
            
            NSLog("Response ==> %@", responseData);
            
            var error: NSError?
            let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
            
            let status:NSString = jsonData.valueForKey("status") as NSString
            
            //[jsonData[@"success"] integerValue];
            
            println("Status: " + status)
            
            checkStatus(status, jsonData: jsonData, vc: vc)
            
            
        } else {
            alert.getStatusCodeError("Logout Failed!", vc: vc)
        }
        
    }
    
    func checkStatus(status: NSString, jsonData: NSDictionary, vc: UIViewController){
        if(status == "success"){
            
            NSLog("Logout SUCCESS");
            logoutProcess(jsonData, vc: vc)
            
        } else {
            alert.getSuccesError(jsonData, str:"Logout Failed!", vc: vc)
        }
        
    }
    
    func logoutProcess(jsonData: NSDictionary, vc: UIViewController){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(0, forKey: "ISLOGGEDIN")
        userDefaults.removeObjectForKey("userInfo")
        userDefaults.removeObjectForKey("USERNAME")
        
        alert.getSuccesLogoutAleart(jsonData, vc: vc)
        if vc is ViewController {
            vc.performSegueWithIdentifier("goto_login", sender: nil)
        }else{
            vc.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func addFriend(url: NSString, receiver: NSString, vc: UIViewController, errorText: NSString){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let username: NSString = prefs.valueForKey("USERNAME") as NSString
        
        var post:NSString = "sender=\(username)&receiver=\(receiver)"
        
        NSLog("PostData: %@",post);
        
        var url:NSURL = NSURL(string: url)!
        
        var request = getRequest(url, post: post)
        
        var responseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
        if ( urlData != nil ) {
            let res = response as NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                
                let jsonData:NSDictionary = getJsonData(urlData!)
                
                let status:NSString = jsonData.valueForKey("status") as NSString
                
                //[jsonData[@"success"] integerValue];
                
                println("Success: " + status)
                
                if(status == "succes")
                {
                    NSLog("ADD SUCCESS");
                    
                } else {
                    alert.getSuccesError(jsonData, str: errorText, vc: vc)
                }
            } else {
                alert.getStatusCodeError(errorText, vc: vc)
            }
        } else {
            alert.getUrlDataError(responseError, str: errorText, vc: vc)
        }

    }
    
    func acceptFriend(receiver: NSString, vc: UIViewController){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {() -> Void in
            
            self.addFriend("http://127.0.0.1:8000/api/accept_friend/", receiver: receiver, vc: vc, errorText: "Accept Friend Failed!")

        })

    }
    
    func rejectFriend(receiver: NSString, vc: UIViewController){
        addFriend("http://127.0.0.1:8000/api/reject_friend/", receiver: receiver, vc: vc, errorText: "Reject Friend Failed!")
    }

    
    
}
