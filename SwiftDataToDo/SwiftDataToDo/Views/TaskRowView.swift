//
//  TaskRowView.swift
//  SwiftDataToDo
//
//  Created by vishva narola on 10/06/25.
//

import SwiftUI

struct TaskRowView: View {
    let task: Task
    let onToggleCompletion: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .gray : .primary)
                
                if let dueDate = task.dueDate {
                    Text("Due: \(dueDate.formatted(.dateTime.day().month().hour().minute()))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                if let reminderDate = task.reminderDate {
                    Text("Reminder: \(reminderDate.formatted(.dateTime.day().month().hour().minute()))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
} 
