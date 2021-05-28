////
////  Reminder.swift
////  masterDet
////
////  Created by user192220 on 5/27/21.
////  Copyright © 2021 Philip Trwoga. All rights reserved.
////
//
import Foundation
import EventKit
import UserNotifications

let eventStore = EKEventStore()


func requestAccess() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
        if success {
            // schedule test
            scheduleReminder()
        }
        else if error != nil {
            print("error occurred")
        }
    })
}


func scheduleReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "My long body. My long body. My long body. My long body. My long body. My long body. "

        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                  from: targetDate),
                                                    repeats: false)

        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
    }


