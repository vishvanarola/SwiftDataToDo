//
//  Task.swift
//  SwiftDataToDo
//
//  Created by vishva narola on 10/06/25.
//

import Foundation
import SwiftData

@Model
final class Task {
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var reminderDate: Date?
    var notes: String?
    var createdDate: Date
    
    init(
        title: String,
        isCompleted: Bool = false,
        dueDate: Date? = nil,
        reminderDate: Date? = nil,
        notes: String? = nil
    ) {
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.reminderDate = reminderDate
        self.notes = notes
        self.createdDate = Date()
    }
}
