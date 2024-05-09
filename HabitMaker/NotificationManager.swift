//
//  NotificationManager.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-05-07.
//

import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    // Begär behörighet för att skicka notifikationer
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if success {
                print("Authorization granted.")
            } else if let error = error {
                print("Authorization error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyReminder(for item: Item, at time: Date) {
        guard let itemId = item.id?.uuidString else {
            print("Item ID is nil")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Don't forget your habit: \(item.name ?? "Unnamed Habit")!"
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        dateComponents.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: itemId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelDailyReminder(for item: Item) {
        guard let itemId = item.id?.uuidString else {
            print("Item ID is nil")
            return
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [itemId])
    }
}
