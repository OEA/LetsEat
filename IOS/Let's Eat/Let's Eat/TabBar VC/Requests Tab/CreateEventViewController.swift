//
//  CreateEventViewController.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 27.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit
import MapKit

class CreateEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var typePV: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var datePV: UIDatePicker!
    @IBOutlet weak var participantLabel: UILabel!
    
    
    @IBOutlet weak var restButton: UIButton!
    @IBOutlet weak var eventName: UITextField!
    
    var participants = [String: Bool]()
    
    var types = ["Meal", "Dinning"]
    let apiMethod = ApiMethods()
    var eventID: Int!
    var joinable = false
    var currountLocation: MKAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDatePicker()
        //apiMethod.createEvent("test", time: "2015-03-31 15:20:00", type: "Meal", restaurant: "Aras", errorText: "Faild", vc: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        if participants.count == 1{
            participantLabel.text = "One Friend"
        }else if participants.count > 1 {
            participantLabel.text = "\(participants.count) Friends"
        }else {
            participantLabel.text = "Add Friends"
        }
    }
    
    func configureDatePicker() {
        let now = NSDate()
        datePV.minimumDate = now
        datePV.timeZone = NSTimeZone.localTimeZone()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationTapped() {
        restButton.setTitle(currountLocation.title, forState: .Normal)
    }
    
    @IBAction func typeTapped(sender: UIButton) {
        typePV.hidden = !typePV.hidden
        doneButton.hidden = !doneButton.hidden
        if typePV.selectedRowInComponent(0) == 0 {
            typeButton.setTitle(types[0], forState: .Normal)
            typeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return types[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeButton.setTitle(types[row], forState: .Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is UIButton{
            let button = sender as! UIButton
            if button.buttonType == UIButtonType.ContactAdd {
                let addPariciantVC = segue.destinationViewController as! AddParticipantViewController
                addPariciantVC.addedFriends = participants
                addPariciantVC.backUIVC = self
            }else if button == restButton{
                let chooseLocationVC = segue.destinationViewController as! LocationChooseViewController
                chooseLocationVC.backUIVC = self
            }
            
        }

    }

    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        let typeText = typeButton.titleLabel?.text
        let restText = restButton.titleLabel?.text?.lowercaseString
        let eventTime = getDate()
        if (!eventName.text.isEmpty) && currountLocation  != nil && typeText != "Edit" && participants.count > 0{
            apiMethod.createEvent(eventName.text, time: eventTime, type: typeText!, restaurant: restText!, errorText: "Faild", joinable: joinable, vc: self)
            if eventID != nil {
                let ec = EventCreator()
                ec.createEvent(eventName.text, location: restText!, eventDate: datePV.date )
                if participants.count > 0 {
                    for friend in participants{
                        apiMethod.inviteEvent(eventID, vc: self, username: friend.0)
                    }
                }
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        /*let rangeOfHello = Range(start: advance(eventTime.startIndex, 5), end: advance(eventTime.startIndex, 5))
        let helloStr = eventTime.substringWithRange(rangeOfHello)*/
    }
    
    @IBAction func checkBoxTapped(sender: UIButton) {
        joinable = !joinable
        if joinable{
            if let image = UIImage(named: "checked-box"){
                sender.setImage(image, forState: UIControlState.Normal)
            }
        }else {
            if let image = UIImage(named: "empty-checkbox"){
                sender.setImage(image, forState: UIControlState.Normal)
            }
        }
    }
    
    func getDate() -> String{
        var dateFormatter = NSDateFormatter()

        //dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle

        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: datePV.date)
        
        var month = "\(components.month)"
        if components.month < 10{
            month = "0" + month
        }
        var day = "\(components.day)"
        if components.day < 10{
            day = "0" + day
        }
        
        var newString = "\(components.year)-\(month)-\(day) "
        var strDate = dateFormatter.stringFromDate(datePV.date)
        newString = newString + strDate
        
        return newString + ":00"
    }
}
