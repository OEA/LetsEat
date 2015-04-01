//
//  DateSetter.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 31.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import Foundation
import UIKit

class DateSetter {
    func getDate(eventTimeStr: String) -> String{
        let date = NSDate()
        //let eventTimeStr = "2015-04-01 12:40:00+00:00"
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        
        let range = Range(start: eventTimeStr.startIndex, end: advance(eventTimeStr.startIndex, 4))
        let yearStr = eventTimeStr.substringWithRange(range)
        let year = yearStr.toInt()
        
        let range2 = Range(start: advance(eventTimeStr.startIndex, 5), end: advance(eventTimeStr.startIndex, 7))
        let monthStr = eventTimeStr.substringWithRange(range2)
        let month = monthStr.toInt()
        
        let range3 = Range(start: advance(eventTimeStr.startIndex, 8), end: advance(eventTimeStr.startIndex, 10))
        let dayStr = eventTimeStr.substringWithRange(range3)
        let day = dayStr.toInt()
        
        let range4 = Range(start: advance(eventTimeStr.startIndex, 11), end: advance(eventTimeStr.startIndex, 13))
        let hourStr = eventTimeStr.substringWithRange(range4)
        let hour = hourStr.toInt()
        
        let range5 = Range(start: advance(eventTimeStr.startIndex, 14), end: advance(eventTimeStr.startIndex, 16))
        let minuteStr = eventTimeStr.substringWithRange(range5)
        let minute = minuteStr.toInt()
        
        components.year = year!
        components.month = month!
        components.day = day!
        components.hour = hour!
        components.minute = minute!
        
        let eventDate = calendar.dateFromComponents(components)!
        
        let difCal = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = .DayCalendarUnit | .HourCalendarUnit
        let differance = difCal.components(unit, fromDate: NSDate(), toDate: eventDate, options: nil)
        
        let todayCalendar = NSCalendar.currentCalendar()
        let todayComp = todayCalendar.components(.CalendarUnitDay, fromDate: date)
        
        var dateFormatter = NSDateFormatter()
        
        if differance.hour < 0 || differance.day < 0{
            return "Passed!"
        }else if todayComp.day == components.day{
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let eventTime = dateFormatter.stringFromDate(eventDate)
            return "Today \(eventTime)"
        }else {
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            let eventTime = dateFormatter.stringFromDate(eventDate)
            return eventTime
        }
    }
}