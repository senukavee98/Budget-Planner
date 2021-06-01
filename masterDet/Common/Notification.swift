//
//  Notification.swift
//  masterDet
//
//  Created by user192220 on 5/17/26.
//

import Foundation
import UserNotifications

class Notification {
    
    func sendNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
            success, error in
            if success {
                self.shedule()
            } else if error != nil {
                print("Error occured")
            }
        })
    }
    
    func shedule()  {
        let content = UNMutableNotificationContent()
        content.title = "Helo World"
        content.sound = .default
        content.body = "My first notification"
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_Id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler:{ error in
            if error != nil {
                print("Some thing went wrong")
            }
        })
    }
    
}



