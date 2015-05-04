//
//  EventCreator.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 4.05.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit
import EventKit

class EventCreator {

    func createEvent(eventName: String, location: String, eventDate: NSDate){
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent) {
            (granted: Bool, err: NSError!) in
            if (granted && err == nil) {
                var event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = eventName
                event.startDate = eventDate
                event.endDate = event.startDate.dateByAddingTimeInterval(3600)
                if let calendar = self.getCalendar(eventStore){
                    event.calendar = calendar
                    event.location = location
                    eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                }
            }
        }
    }
    
    func getCalendar(eventStore: EKEventStore) -> EKCalendar? {

        var calendar: EKCalendar!
        let calendarIdentifier = "Lets Eat"
        
        let localCalendars = eventStore.calendarsForEntityType(EKEntityTypeEvent)  as! [EKCalendar]
        for cal in localCalendars {
            if (cal.title == calendarIdentifier) {
                return cal
            }
        }
        // calendar doesn't exist, create it and save it's identifier
        if (calendar == nil) {
            calendar = EKCalendar(forEntityType: EKEntityTypeEvent, eventStore: eventStore)
            
            calendar.title = calendarIdentifier
            
            var sources = eventStore.sources() as! [EKSource]
            var cloudExist = false
            for s in sources{
                if (s.sourceType.value == 2) {
                    println("2!!!!!!!")
                    calendar.source = s;
                    cloudExist = true
                    break;
                }
            }
            if !cloudExist {
                for s in sources{
                    if (s.sourceType.value == 0) {
                        //println("0!!!!!!")
                        calendar.source = s;
                        break;
                    }
                }
            }
            
            var saved = eventStore.saveCalendar(calendar, commit: true, error: nil)
            if (saved) {
                return calendar
            }
        }
        return nil
    }
}