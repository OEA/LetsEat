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
        userDefaults.removeObjectForKey("Friends")
        userDefaults.removeObjectForKey("USERNAME")
        
        alert.getSuccesLogoutAleart(jsonData, vc: vc)
        if vc is ViewController {
            vc.performSegueWithIdentifier("goto_login", sender: nil)
        }else{
            vc.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func getOwnedEvent(vc: UIViewController){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {() -> Void in
            let errorText = "Get Owned Events Failed"
            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let username = prefs.valueForKey("USERNAME") as NSString
            var post:NSString = "username=\(username)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/get_owned_events/")!
            
            var request = self.getRequest(url, post: post)
            
            var responseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
            if ( urlData != nil ) {
                let res = response as NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    
                    let jsonData:NSDictionary = self.getJsonData(urlData!)
                    
                    let status:NSString = jsonData.valueForKey("status") as NSString
                    
                    //[jsonData[@"success"] integerValue];
                    
                    println("Success: " + status)
                    
                    if(status == "success")
                    {
                        NSLog("Get Owned SUCCESS");
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if vc is OwnedEventsTableViewController{
                                let viewC = vc as OwnedEventsTableViewController
                                viewC.ownedEventList = jsonData.valueForKey("events") as [[String: AnyObject]]
                                viewC.eventTBV.reloadData()
                            }else{
                                self.goBack(vc)
                            }
                        })
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.alert.getSuccesError(jsonData, str: errorText, vc: vc)
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.alert.getStatusCodeError(errorText, vc: vc)
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.alert.getUrlDataError(responseError, str: errorText, vc: vc)
                })
            }
        })
        
    }
    
    func addGroupMember(url: NSString, member: NSString, vc: UIViewController, errorText: NSString, group_id: NSString){
        let urll2 = "http://127.0.0.1:8000/api/add_group_member/"
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {() -> Void in
            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            let user = prefs.valueForKey("USERNAME") as NSString
            var post:NSString = "username=\(user)&member=\(member)&group_id=\(group_id)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: urll2)!
            
            var request = self.getRequest(url, post: post)
            
            var responseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
            if ( urlData != nil ) {
                let res = response as NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    
                    let jsonData:NSDictionary = self.getJsonData(urlData!)
                    
                    let status:NSString = jsonData.valueForKey("status") as NSString
                    
                    //[jsonData[@"success"] integerValue];
                    
                    println("Success: " + status)
                    
                    if(status == "success")
                    {
                        NSLog("ADD SUCCESS");
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if vc is RequestsTableViewController{
                                let viewC = vc as RequestsTableViewController
                                let fVC = FriendsViewController()
                                fVC.getFriendList()
                                self.getUserRequests(viewC)
                                viewC.friendReqtTV.reloadData()
                            }else{
                                self.goBack(vc)
                            }
                        })
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.alert.getSuccesError(jsonData, str: errorText, vc: vc)
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.alert.getStatusCodeError(errorText, vc: vc)
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.alert.getUrlDataError(responseError, str: errorText, vc: vc)
                })
            }
        })
        
    }
    
    func addFriend(url: NSString, receiver: NSString, vc: UIViewController, errorText: NSString, sender: NSString){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {() -> Void in
            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            
            var post:NSString = "sender=\(sender)&receiver=\(receiver)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: url)!
            
            var request = self.getRequest(url, post: post)
            
            var responseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
            if ( urlData != nil ) {
                let res = response as NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    
                    let jsonData:NSDictionary = self.getJsonData(urlData!)
                    
                    let status:NSString = jsonData.valueForKey("status") as NSString
                    
                    //[jsonData[@"success"] integerValue];
                    
                    println("Success: " + status)
                    
                    if(status == "success")
                    {
                        NSLog("ADD SUCCESS");
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if vc is RequestsTableViewController{
                                let viewC = vc as RequestsTableViewController
                                let fVC = FriendsViewController()
                                fVC.getFriendList()
                                self.getUserRequests(viewC)
                                viewC.friendReqtTV.reloadData()
                            }else{
                                self.goBack(vc)
                            }
                        })
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.alert.getSuccesError(jsonData, str: errorText, vc: vc)
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.alert.getStatusCodeError(errorText, vc: vc)
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.alert.getUrlDataError(responseError, str: errorText, vc: vc)
                })
            }
        })
        
    }
    
    func getUserRequest(urlStr: NSString, vc: RequestsTableViewController, errorText: NSString, type: Int){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let username: NSString = prefs.valueForKey("USERNAME") as NSString
        
        var post:NSString = "username=\(username)"
        
        NSLog("PostData: %@",post);
        
        var url:NSURL = NSURL(string: urlStr)!
        
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
                
                let status:NSString = "success"/*jsonData.valueForKey("status") as NSString*/
                
                //[jsonData[@"success"] integerValue];
                
                println("Success: " + status)
                
                if(status == "success")
                {
                    NSLog("SUCCESS");
                    
                    println(jsonData)
                    if type == 1{
                        vc.eventReqList = jsonData["events_requests"] as NSArray
                    }else {
                        vc.friendRequestList = jsonData["senders"] as NSArray
                    }
                    vc.friendReqtTV.reloadData()
                } else {
                    alert.getSuccesError(jsonData, str:errorText, vc: vc)
                }
            } else {
                alert.getStatusCodeError(errorText, vc:vc)
            }
        } else {
            alert.getUrlDataError(responseError, str:errorText, vc: vc)
        }
        
    }
    
    func getUserRequests(vc: RequestsTableViewController){
        getUserRequest("http://127.0.0.1:8000/api/get_event_requests/", vc: vc, errorText: "Get Event Failed!", type: 1)
        getUserRequest("http://127.0.0.1:8000/api/get_friend_requests/", vc: vc, errorText: "Get Friend Failed!", type: 2)
    }
    
    func createEvent(eventName: NSString, time: NSString, type: NSString, restaurant: NSString, errorText: NSString, vc: UIViewController){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let username = prefs.valueForKey("USERNAME") as NSString
        
        var post:NSString = "name=\(eventName)&restaurant=\(restaurant)&owner=\(username)&type=\(type)&start_time=\(time)&joinable=\(1)"
        
        NSLog("PostData: %@",post);
        
        var url:NSURL = NSURL(string: "http://127.0.0.1:8000/api/create_event/")!
        
        var request = self.getRequest(url, post: post)
        
        var responseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
        if ( urlData != nil ) {
            let res = response as NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                
                let jsonData:NSDictionary = self.getJsonData(urlData!)
                
                let status:NSString = jsonData.valueForKey("status") as NSString
                
                //[jsonData[@"success"] integerValue];
                
                println("Success: " + status)
                
                if(status == "success")
                {
                    NSLog("ADD SUCCESS");
                    let event = jsonData.valueForKey("event") as [String: AnyObject]
                    let viewC = vc as CreateEventViewController
                    viewC.eventID = event["id"] as Int
                    println(jsonData)
                } else {
                        self.alert.getSuccesError(jsonData, str: errorText, vc: vc)
                }
            } else {

                    self.alert.getStatusCodeError(errorText, vc: vc)

            }
        } else {

                self.alert.getUrlDataError(responseError, str: errorText, vc: vc)
        
        }

    }
    
    func eventRqst(url: NSString, event: Int, vc: UIViewController, errorText: NSString, username: NSString){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {() -> Void in
        
        
        var post:NSString = "event=\(event)&participant=\(username)"
        
        NSLog("PostData: %@",post);
        
        var url:NSURL = NSURL(string: url)!
        
        var request = self.getRequest(url, post: post)
        
        var responseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError)
        if ( urlData != nil ) {
            let res = response as NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                
                let jsonData:NSDictionary = self.getJsonData(urlData!)
                
                let status:NSString = jsonData.valueForKey("status") as NSString
                
                //[jsonData[@"success"] integerValue];
                
                println("Success: " + status)
                
                if(status == "success")
                {
                    NSLog("SUCCESS");
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if vc is RequestsTableViewController{
                            let viewC = vc as RequestsTableViewController
                            self.getOwnedEvent(vc)
                            viewC.friendReqtTV.reloadData()
                        }else{
                            self.goBack(vc)
                        }
                    })
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.alert.getSuccesError(jsonData, str: errorText, vc: vc)
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.alert.getStatusCodeError(errorText, vc: vc)
                })
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.alert.getUrlDataError(responseError, str: errorText, vc: vc)
            })
        }
        })

    }
    
    func inviteEvent(event: Int, vc: UIViewController, username: NSString){
        
        eventRqst("http://127.0.0.1:8000/api/invite_event/", event: event, vc: vc, errorText: "Invite Friends Failed", username: username)
    }
    
    func acceptEvent(event: Int, vc: UIViewController){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let username = prefs.valueForKey("USERNAME") as NSString
        eventRqst("http://127.0.0.1:8000/api/accept_event/", event: event, vc: vc, errorText: "Accept Event Failed", username: username)
    }
    
    func rejectEvent(event: Int, vc: UIViewController){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let username = prefs.valueForKey("USERNAME") as NSString
        eventRqst("http://127.0.0.1:8000/api/reject_event/", event: event, vc: vc, errorText: "Reject Event Failed", username: username)
    }
    
    func goBack(vc: UIViewController){
        vc.navigationController?.popViewControllerAnimated(true)
    }
    
    func acceptFriend(sender: NSString, vc: UIViewController){
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let username: NSString = userDefaults.valueForKey("USERNAME") as NSString
            
            self.addFriend("http://127.0.0.1:8000/api/accept_friend/", receiver: username, vc: vc, errorText: "Accept Friend Failed!", sender: sender)
    }
    
    func rejectFriend(sender: NSString, vc: UIViewController){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let username: NSString = userDefaults.valueForKey("USERNAME") as NSString
        
        addFriend("http://127.0.0.1:8000/api/reject_friend/", receiver: username, vc: vc, errorText: "Reject Friend Failed!", sender: sender)
    }

    
    
}
