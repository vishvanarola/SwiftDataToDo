//
//  NotificationManager.swift
//  SwiftDataToDo
//
//  Created by vishva narola on 10/06/25.
//

import Foundation
import UIKit
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(for task: Task) {
        guard let reminderDate = task.reminderDate else {
            // If there's no reminder date, make sure to cancel any existing notifications
            cancelNotification(for: task)
            return
        }
        
        // Only schedule if reminder date is in the future
        guard reminderDate > Date() else {
            print("Cannot schedule notification for past date")
            cancelNotification(for: task)
            return
        }
        
        // Cancel any existing notifications for this task
        cancelNotification(for: task)
        
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = task.title
        content.sound = .default
        
        if let dueDate = task.dueDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            content.subtitle = "Due: \(formatter.string(from: dueDate))"
        }
        
        // Calculate time interval from now
        let timeInterval = reminderDate.timeIntervalSinceNow
        
        // Create time interval trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let identifier = "task-\(task.createdDate.timeIntervalSince1970)"
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // Remove any existing notifications first
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // Schedule the new notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Successfully scheduled/updated notification for task: \(task.title) at \(reminderDate)")
                
                // Print all pending notifications for debugging
                self.checkPendingNotifications()
            }
        }
    }
    
    func updateNotification(for task: Task) {
        // First cancel the existing notification
        cancelNotification(for: task)
        
        // Then schedule a new one if needed
        if let reminderDate = task.reminderDate {
            if reminderDate > Date() {
                scheduleNotification(for: task)
                print("Updating notification for task: \(task.title) to new time: \(reminderDate)")
            } else {
                print("Cannot update notification: reminder date is in the past")
            }
        } else {
            print("Removed notification for task: \(task.title) as reminder was removed")
        }
    }
    
    func cancelNotification(for task: Task) {
        let identifier = "task-\(task.createdDate.timeIntervalSince1970)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Cancelled notification for task: \(task.title)")
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Cancelled all notifications")
    }
    
    func checkPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("\n=== Pending Notifications (\(requests.count)) ===")
            for request in requests {
                if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                    print("ID: \(request.identifier)")
                    print("Title: \(request.content.title)")
                    print("Body: \(request.content.body)")
                    print("Will fire in: \(trigger.timeInterval) seconds")
                    print("Scheduled for: \(Date(timeIntervalSinceNow: trigger.timeInterval))")
                    print("---")
                }
            }
            print("=====================================\n")
        }
    }
} 
