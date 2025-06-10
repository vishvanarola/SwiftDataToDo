//
//  ToDoListView.swift
//  SwiftDataToDo
//
//  Created by vishva narola on 10/06/25.
//

import SwiftUI
import SwiftData

struct ToDoListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddTask = false
    @State private var selectedTask: Task?
    
    @Query(sort: \Task.createdDate, order: .reverse) private var tasks: [Task]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    TaskRowView(task: task) {
                        TaskViewModel(modelContext: modelContext)
                            .toggleTaskCompletion(task)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            TaskViewModel(modelContext: modelContext)
                                .deleteTask(task)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            selectedTask = task
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Tasks")
                        .font(.system(size: 25, weight: .bold))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                TaskFormView { title, dueDate, reminderDate, notes in
                    TaskViewModel(modelContext: modelContext)
                        .addTask(
                            title: title,
                            dueDate: dueDate,
                            reminderDate: reminderDate,
                            notes: notes
                        )
                }
            }
            .sheet(item: $selectedTask) { task in
                TaskFormView(task: task) { title, dueDate, reminderDate, notes in
                    task.title = title
                    task.dueDate = dueDate
                    task.reminderDate = reminderDate
                    task.notes = notes
                    
                    TaskViewModel(modelContext: modelContext)
                        .updateTask(task)
                }
            }
        }
    }
}
