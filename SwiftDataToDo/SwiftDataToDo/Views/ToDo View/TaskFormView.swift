//
//  TaskFormView.swift
//  SwiftDataToDo
//
//  Created by vishva narola on 10/06/25.
//

import SwiftUI

struct TaskFormView: View {
    @Environment(\.dismiss) private var dismiss
    let task: Task?
    var onSave: (String, Date?, Date?, String?) -> Void
    
    @State private var title: String
    @State private var dueDate: Date?
    @State private var reminderDate: Date?
    @State private var notes: String
    @State private var isDueDateEnabled: Bool
    @State private var isReminderEnabled: Bool
    
    init(task: Task? = nil, onSave: @escaping (String, Date?, Date?, String?) -> Void) {
        self.task = task
        self.onSave = onSave
        
        _title = State(initialValue: task?.title ?? "")
        _dueDate = State(initialValue: task?.dueDate)
        _reminderDate = State(initialValue: task?.reminderDate)
        _notes = State(initialValue: task?.notes ?? "")
        _isDueDateEnabled = State(initialValue: task?.dueDate != nil)
        _isReminderEnabled = State(initialValue: task?.reminderDate != nil)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    
                    Toggle("Set Due Date", isOn: $isDueDateEnabled)
                    
                    if isDueDateEnabled {
                        DatePicker("Due Date",
                                   selection: Binding(
                                    get: { dueDate ?? Date() },
                                    set: { dueDate = $0 }
                                   ),
                                   displayedComponents: [.date, .hourAndMinute])
                    }
                    
                    Toggle("Set Reminder", isOn: $isReminderEnabled)
                    
                    if isReminderEnabled {
                        DatePicker("Reminder",
                                   selection: Binding(
                                    get: { reminderDate ?? Date() },
                                    set: { reminderDate = $0 }
                                   ),
                                   displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(task == nil ? "New Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let finalDueDate = isDueDateEnabled ? dueDate : nil
                        let finalReminderDate = isReminderEnabled ? reminderDate : nil
                        
                        onSave(title, finalDueDate, finalReminderDate, notes.isEmpty ? nil : notes)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .onChange(of: isDueDateEnabled) { _, isEnabled in
                if isEnabled && dueDate == nil {
                    dueDate = Date()
                } else if !isEnabled {
                    dueDate = nil
                }
            }
            .onChange(of: isReminderEnabled) { _, isEnabled in
                if isEnabled && reminderDate == nil {
                    reminderDate = Date()
                } else if !isEnabled {
                    reminderDate = nil
                }
            }
        }
    }
}
