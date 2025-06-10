//
//  TaskViewModel.swift
//  SwiftDataToDo
//
//  Created by vishva narola on 10/06/25.
//

import Foundation
import SwiftData

@Observable
class TaskViewModel {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addTask(title: String, dueDate: Date? = nil, reminderDate: Date? = nil, notes: String? = nil) {
        let task = Task(title: title, dueDate: dueDate, reminderDate: reminderDate, notes: notes)
        modelContext.insert(task)
        NotificationManager.shared.scheduleNotification(for: task)
        save()
    }
    
    func updateTask(_ task: Task) {
        NotificationManager.shared.updateNotification(for: task)
        save()
    }
    
    func deleteTask(_ task: Task) {
        NotificationManager.shared.cancelNotification(for: task)
        modelContext.delete(task)
        save()
    }
    
    func toggleTaskCompletion(_ task: Task) {
        task.isCompleted.toggle()
        if task.isCompleted {
            NotificationManager.shared.cancelNotification(for: task)
        } else if let reminderDate = task.reminderDate, reminderDate > Date() {
            NotificationManager.shared.scheduleNotification(for: task)
        }
        save()
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
