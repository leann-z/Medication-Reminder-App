//
//  NotificationHandler.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/24/23.
//

import Foundation
import UserNotifications

class NotificationHandler {
    
    
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Access granted!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func sendNotification(time: Date, freq: String, type: String, title: String, body: String){
        //var trigger: UNNotificationTrigger?
        var frequencyTrigger: UNNotificationTrigger?
        
       
           let calendar = Calendar.current
           let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
           let timeTrigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: true)
        
        if let interval = getNotificationInterval(for: freq) {
            frequencyTrigger  = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        }
            
        //trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        
        let content = UNMutableNotificationContent()
        //var shelvesviewModel: ShelvesviewModel
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let timeRequest = UNNotificationRequest(identifier: UUID().uuidString + "-time", content: content, trigger: timeTrigger)
            UNUserNotificationCenter.current().add(timeRequest)
        
        if let frequencyTrigger = frequencyTrigger {
               let frequencyRequest = UNNotificationRequest(identifier: UUID().uuidString + "-frequency", content: content, trigger: frequencyTrigger)
               UNUserNotificationCenter.current().add(frequencyRequest)
           }
        
       // let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
       // UNUserNotificationCenter.current().add(request)
    }
    func getNotificationInterval(for freq: String) -> TimeInterval? {
        switch freq {
        case "daily":
            return 24 * 60 * 60 // 24 hours in seconds (daily)
        case "weekly":
            return 7 * 24 * 60 * 60 // 7 days in seconds (weekly)
        case "biweekly":
            return 14 * 24 * 60 * 60 // 14 days in seconds (biweekly)
        case "monthly":
            return 30 * 24 * 60 * 60 // 30 days in seconds (monthly, approximate)
        default:
            return nil // Handle unsupported frequency options or provide a default interval
        }
    }
}
