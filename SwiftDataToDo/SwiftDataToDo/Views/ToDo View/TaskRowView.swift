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
        HStack(spacing: 16) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    onToggleCompletion()
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .symbolEffect(.bounce, value: task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)
                
                if !task.isCompleted {
                    Group {
                        if let dueDate = task.dueDate {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.caption)
                                Text(dueDate.formatted(.dateTime.day().month().hour().minute()))
                            }
                            .foregroundStyle(dueDate < Date() ? .red : .secondary)
                        }
                        
                        if let reminderDate = task.reminderDate {
                            HStack(spacing: 4) {
                                Image(systemName: "bell")
                                    .font(.caption)
                                Text(reminderDate.formatted(.dateTime.day().month().hour().minute()))
                            }
                            .foregroundStyle(reminderDate < Date() ? .red : .secondary)
                        }
                    }
                    .font(.caption)
                }
                
                if let notes = task.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            if !task.isCompleted {
                if let dueDate = task.dueDate, dueDate < Date() {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(.red)
                        .symbolEffect(.pulse)
                }
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical, 4)
    }
} 
