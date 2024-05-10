//
//  NotificationManager.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-05-10.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func scheduleDailyReminder(for item: Item, at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder"
        content.body = "Don't forget your \(item.name ?? "item")!"
        content.sound = UNNotificationSound.default

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: item.id!.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func cancelDailyReminder(for item: Item) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id!.uuidString])
    }
}
