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
        
        // ❌ Only remove previous notifications for THIS medicine
        center.removePendingNotificationRequests(withIdentifiers: notificationIdentifiers(for: title, freq: freq))

        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        var days: [Int] = []

        switch freq.lowercased() {
                case "daily":
                    days = [1, 2, 3, 4, 5, 6, 7]
                case "weekdays":
                    days = [2, 3, 4, 5, 6]
                case "weekends":
                    days = [1, 7]
                case let freq where freq.starts(with: "every ") && freq.contains(" days"):
                    if let dayInterval = Int(freq.components(separatedBy: " ")[1]) {
                        let nextFireDate = Calendar.current.date(byAdding: .day, value: dayInterval, to: time) ?? time
                        let nextFireComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nextFireDate)

                        let content = UNMutableNotificationContent()
                        content.title = "\(type): \(title)"
                        content.body = body
                        content.sound = .default

                        let request = UNNotificationRequest(
                            identifier: "every_\(dayInterval)_\(title)",
                            content: content,
                            trigger: UNCalendarNotificationTrigger(dateMatching: nextFireComponents, repeats: true)
                        )

                        center.add(request)
                        print("✅ Scheduled Every \(dayInterval) Days for \(title)")
                        return
                    }
                case "biweekly":
                    scheduleBiweeklyNotification(time: time, title: title, body: body)
                    return
                default:
                    print("Invalid frequency: \(freq)")
                    return
                }

                for day in days {
                    var dateComponents = timeComponents
                    dateComponents.weekday = day

                    let content = UNMutableNotificationContent()
                    content.title = "\(type): \(title)"
                    content.body = body
                    content.sound = .default

                    let identifier = "weekday_\(day)_\(title)"

                    let request = UNNotificationRequest(
                        identifier: identifier,
                        content: content,
                        trigger: UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    )

                    center.add(request)
                    print("✅ Scheduled for weekday \(day) at \(timeComponents.hour!):\(timeComponents.minute!)")
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

        let initialID = "biweekly_initial_\(title)"
              let request = UNNotificationRequest(
                  identifier: initialID,
                  content: content,
                  trigger: UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
              )

              center.add(request) { error in
                  if error == nil {
                      print("✅ Scheduled first biweekly notification for \(title)")
                      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                          self.scheduleRecurringBiweeklyNotification(startingFrom: time, title: title, body: body)
                      }
                  } else {
                      print("❌ Failed initial biweekly: \(error!.localizedDescription)")
                  }
              }
          }

    // 🔁 **Schedules the repeating notification every 14 days after the first one**
    private func scheduleRecurringBiweeklyNotification(startingFrom lastDate: Date, title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        let interval: TimeInterval = 14 * 24 * 60 * 60

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(
            identifier: "biweekly_recurring_\(title)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        )

        center.add(request) { error in
            if error == nil {
                print("✅ Scheduled recurring biweekly for \(title)")
            } else {
                print("❌ Recurring biweekly failed: \(error!.localizedDescription)")
            }
        }
    }
    
    func scheduleRefillReminder(date: Date, title: String) {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        
        // 🔹 Remove existing refill for this title
        center.removePendingNotificationRequests(withIdentifiers: ["refill_\(title)"])
        
        var refillDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        refillDateComponents.hour = 9
        
        let content = UNMutableNotificationContent()
        content.title = "Refill Reminder: \(title)"
        content.body = "Time to refill your medicine! Open PillMinder to set a new refill date."
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "refill_\(title)",
            content: content,
            trigger: UNCalendarNotificationTrigger(dateMatching: refillDateComponents, repeats: false)
        )
        
        center.add(request) { error in
            if error == nil {
                print("✅ Refill reminder scheduled for \(title)")
            } else {
                print("❌ Refill failed: \(error!.localizedDescription)")
            }
        }
    }
    
    // helper function to generate identifiers based on frequency
    private func notificationIdentifiers(for title: String, freq: String) -> [String] {
        switch freq.lowercased() {
        case "daily":
            return (1...7).map { "weekday_\($0)_\(title)" }
        case "weekdays":
            return (2...6).map { "weekday_\($0)_\(title)" }
        case "weekends":
            return [1, 7].map { "weekday_\($0)_\(title)" }
        case let str where str.starts(with: "every ") && str.contains(" days"):
            if let num = Int(str.components(separatedBy: " ")[1]) {
                return ["every_\(num)_\(title)"]
            }
        case "biweekly":
            return ["biweekly_initial_\(title)", "biweekly_recurring_\(title)"]
        default:
            return []
        }
        return []
    }
}
