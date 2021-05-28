//
//  AddExpenceViewController.swift
//  masterDet
//
//  Created by user192220 on 5/17/21.
//

import UIKit
import CoreData
import UserNotifications

class AddExpenceViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var budget: Budget?
    var expence: Expence?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pickedDate: Date = Date()
    var spent = 0.0
    var expenceName:String?
    
    @IBOutlet weak var textFieldExpencename: UITextField!
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var textViewNotes: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var switchEvent: UISwitch!
    @IBOutlet weak var switchReminder: UISwitch!
    
    let notificationCenter = UNUserNotificationCenter.current()
    var detailVC = DetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchEvent.isOn = false
        switchReminder.isOn = false
        datePicker.minimumDate = Date()
        notificationCenter.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleSelectedDate(_ sender: UIDatePicker) {
        pickedDate = sender.date
    }
    
    @IBAction func handleAddExpence(_ sender: UIButton) {
        print(detailVC.total_expence_value, "<<<<<<<<<<<<<<<<<<<<<")
        let expence = Expence(context: context)
        
        //info for calendar event
        if switchEvent.isOn == true {
        let eventHelper = EventHelper(
            eventName: self.textFieldExpencename.text ?? "",
            date: self.pickedDate,
            notes: self.textViewNotes.text
        )
        
        eventHelper.grantEvent()
        }
        
        if switchReminder.isOn == true {
            notify()
        }
        
        
        expenceName = self.textFieldExpencename.text
        expence.expence_name = self.textFieldExpencename.text
        expence.expence_amount = Double(self.textFieldAmount.text ?? "") ?? 0.0
        expence.notes = self.textViewNotes.text
        expence.due_date = self.pickedDate
        budget?.addToExpences(expence)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
    // Request Authorization
    notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
        if let error = error {
            print("Request Authorization Failed (\(error), \(error.localizedDescription))")
        }
        completionHandler(success)
    }
}

func scheduleLocalNotification(_ title: String, subtitle: String, body: String, date: Date) {
    // Create Notification Content
    let notificationContent = UNMutableNotificationContent()
    let identifier = "\(UUID().uuidString)"
    
    // Configure Notification Content
    notificationContent.title = title
    notificationContent.subtitle = subtitle
    notificationContent.body = body
    
    // Add Trigger
    // let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 20.0, repeats: false)
    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
    // Create Notification Request
    let notificationRequest = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
    
    // Add Request to User Notification Center
    notificationCenter.add(notificationRequest) { (error) in
        if let error = error {
            print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
        }
    }
}
    
    let date = Date()

func notify() {
    notificationCenter.getNotificationSettings { (notificationSettings) in
        switch notificationSettings.authorizationStatus {
        case .notDetermined:
            self.requestAuthorization(completionHandler: { (success) in
                guard success else { return }
                print("Scheduling Notifications")
                // Schedule Local Notification
                self.scheduleLocalNotification("Your payment due on today!", subtitle: "Expence \(self.expenceName ?? "need to be done today")", body: "Your expence need to be fullfill today - \(self.expenceName ?? "SOON!")). Due on \(self.pickedDate)", date: self.pickedDate)
                print("Scheduled Notifications")
            })
        case .authorized:
            
            // Schedule Local Notification
            self.scheduleLocalNotification("Your payment due on today!", subtitle: "Expence \(self.expenceName ?? "need to be done today")", body: "Your expence need to be fullfill today - \(self.expenceName ?? "SOON!")). Due on \(self.pickedDate)", date: self.pickedDate)
            print("Scheduled Notifications")
        case .denied:
            print("Application Not Allowed to Display Notifications")
        case .provisional:
            print("Application Not Allowed to Display Notifications")
        case .ephemeral:
            print("Application Not Allowed to Display Notifications")
        @unknown default:
            break
        }
    }
}

func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert])
}
}
