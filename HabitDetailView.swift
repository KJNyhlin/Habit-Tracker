//
//  HabitDetailView.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-05-07.
//

import Foundation
import SwiftUI
import UserNotifications

struct ItemDetailView: View {
    @ObservedObject var item: Item
    @Environment(\.managedObjectContext) private var viewContext
    @State private var reminderEnabled: Bool = false

    var body: some View {
        VStack {
            Text("Details for \(item.name ?? "Ingen titel")")
            // ... övrig kod ...

            Toggle("Enable Daily Reminder", isOn: $reminderEnabled)
                .onChange(of: reminderEnabled) { isEnabled in
                    if isEnabled {
                        requestNotificationsPermission()
                    } else {
                        NotificationManager.shared.cancelDailyReminder(for: item)
                    }
                }

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func requestNotificationsPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                // Begär behörigheter om inte redan begärda
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    DispatchQueue.main.async {
                        if granted {
                            scheduleDailyReminder()
                        } else {
                            // Hantera om användaren nekar behörighet
                            reminderEnabled = false
                        }
                    }
                }
            } else if settings.authorizationStatus == .authorized {
                // Schemalägg påminnelsen direkt om redan godkänd
                scheduleDailyReminder()
            } else {
                // Hantera om behörigheter redan nekats
                DispatchQueue.main.async {
                    reminderEnabled = false
                }
            }
        }
    }

    private func scheduleDailyReminder() {
        NotificationManager.shared.scheduleDailyReminder(for: item, at: Date())
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Time to maintain your habit: \(item.name ?? "your habit")!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 14
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: item.id!.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling reminder: \(error)")
            }
        }
        item.reminderEnabled = true
        saveContext()
    }

    private func cancelDailyReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id!.uuidString])
        item.reminderEnabled = false
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

let itemDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    if let timeZone = TimeZone(identifier: "Europe/Stockholm") {
        formatter.timeZone = timeZone
    } else {
        print("Failed to set timezone")
    }
    return formatter
}()

