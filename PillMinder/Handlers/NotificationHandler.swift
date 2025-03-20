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
    func sendNotification(time: Date, freq: String, type: String, title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        
        print("🚀 sendNotification() called for \(title) with frequency: \(freq)")
        
        // Remove all previous notifications to avoid duplicates, um does this remove notifs for other medication?
        center.removeAllPendingNotificationRequests()

        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        var days: [Int] = []

        // Map user-selected notification frequency to actual weekdays
        switch freq.lowercased() {
        case "daily":
            days = [1, 2, 3, 4, 5, 6, 7] // Every day
        case "weekdays":
            days = [2, 3, 4, 5, 6] // Monday to Friday
        case "weekends":
            days = [1, 7] // Sunday & Saturday
        case let freq where freq.starts(with: "every ") && freq.contains(" days"):
            if let days = Int(freq.components(separatedBy: " ")[1]) { // Extracts the number part
                let nextFireDate = Calendar.current.date(byAdding: .day, value: days, to: time) ?? time
                let nextFireComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nextFireDate)

                let trigger = UNCalendarNotificationTrigger(dateMatching: nextFireComponents, repeats: true)

                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default

                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request) { error in
                    if let error = error {
                        print("❌ Error scheduling Every \(days) Days notification: \(error.localizedDescription)")
                    } else {
                        print("✅ Successfully scheduled Every \(days) Days notification at \(nextFireComponents.hour!):\(nextFireComponents.minute!) on \(nextFireDate)")
                    }
                }
                return
            }
        case "biweekly":
            scheduleBiweeklyNotification(time: time, title: title, body: body)
            return
        default:
            print("Invalid frequency:  \(freq)")
            return
        }

        // Schedule notification for each selected day
        for day in days {
            var dateComponents = timeComponents
            dateComponents.weekday = day
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let content = UNMutableNotificationContent()
            content.title = "\(type): \(title)"  // Now `type` is used in the title
            content.body = body
            content.sound = UNNotificationSound.default

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
            print("Scheduled \(freq) notification for weekday: \(day) at \(timeComponents.hour!):\(timeComponents.minute!)")
        }
    }
    
    private func scheduleBiweeklyNotification(time: Date, title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current

        // Extract the user's selected date and time
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: time)

        // Schedule the first notification on the selected day
        let firstTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let requestID = "biweekly_initial_\(title)"
        let request = UNNotificationRequest(identifier: requestID, content: content, trigger: firstTrigger)

        center.add(request) { error in
            if error == nil {
                print("Scheduled first biweekly notification on \(time)")
                
                // After the first notification, set up the biweekly repeating notifications
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.scheduleRecurringBiweeklyNotification(startingFrom: time, title: title, body: body)
                }
            } else {
                print("Failed to schedule first biweekly notification: \(error!.localizedDescription)")
            }
        }
    }

    // 🔁 **Schedules the repeating notification every 14 days after the first one**
    private func scheduleRecurringBiweeklyNotification(startingFrom lastDate: Date, title: String, body: String) {
        let center = UNUserNotificationCenter.current()

        let interval: TimeInterval = 14 * 24 * 60 * 60 // 14 days in seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let requestID = "biweekly_recurring_\(title)"
        let request = UNNotificationRequest(identifier: requestID, content: content, trigger: trigger)

        center.add(request) { error in
            if error == nil {
                print("Scheduled recurring biweekly notification every 14 days after \(lastDate)")
            } else {
                print(" Failed to schedule recurring biweekly notification: \(error!.localizedDescription)")
            }
        }
    }
    
    func scheduleRefillReminder(date: Date, title: String) {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current

        var refillDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        refillDateComponents.hour = 9  // 🔹 Schedule for 9AM

        let trigger = UNCalendarNotificationTrigger(dateMatching: refillDateComponents, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = "Refill Reminder: \(title)"
        content.body = "Time to refill your medicine! Open PillMinder to set a new refill date."
        content.sound = UNNotificationSound.default

        let requestID = "refill_\(title)_\(date.timeIntervalSince1970)"
        let request = UNNotificationRequest(identifier: requestID, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("❌ Error scheduling refill reminder: \(error.localizedDescription)")
            } else {
                print("✅ Successfully scheduled refill reminder for \(title) on \(date)")
            }
        }
    }
    
}
