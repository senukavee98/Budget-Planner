//
//  EventHelper.swift
//  masterDet
//
//  Created by user192220 on 5/17/25.
//


import EventKit

class EventHelper {
    var eventName:String
    var date: Date
    var notes: String
    
    init(eventName: String, date:Date, notes:String) {
        self.eventName = eventName
        self.date = date
        self.notes = notes
    }
    
    let eventStore = EKEventStore()
    var calender: [EKCalendar]?
    
    func  grantEvent() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch status {
        case EKAuthorizationStatus.notDetermined:
            requestAccessCalendar()
            
        case EKAuthorizationStatus.authorized:
            print("User has Calendar Access")
            self.addEvent()
            
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            noPermission()
        default:
            break
        }
    }
    
    func noPermission()
    {
     print("User has to change the settings. Goto settings to view access")
    }
    
    func requestAccessCalendar() {
        eventStore.requestAccess(to: .event, completion: {(granted, error) in
            if granted, error == nil {
                DispatchQueue.main.async {
                    print("User has access to calendar")
                    self.addEvent()
                }
            } else {
                DispatchQueue.main.async {
                    self.noPermission()
                }
            }
        })
    }
    
    func addEvent() {
        let event: EKEvent = EKEvent(eventStore: eventStore)
        event.title = self.eventName
        event.startDate = self.date
        event.endDate = self.date
        event.notes = self.notes
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            print("Event Added")
        } catch let e as NSError {
            print(e.description)
            return
        }
        print("event Saved")
    }
 
}

