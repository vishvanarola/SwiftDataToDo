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
    @State private var selectedFilter: TaskFilter = .all
    @State private var searchText = ""
    
    @Query(sort: \Task.createdDate, order: .reverse) private var tasks: [Task]
    
    enum TaskFilter {
        case all, active, completed
        
        var title: String {
            switch self {
            case .all: return "All"
            case .active: return "Active"
            case .completed: return "Completed"
            }
        }
    }
    
    var filteredTasks: [Task] {
        tasks.filter { task in
            let matchesFilter: Bool = {
                switch selectedFilter {
                case .all: return true
                case .active: return !task.isCompleted
                case .completed: return task.isCompleted
                }
            }()
            
            if searchText.isEmpty {
                return matchesFilter
            } else {
                return matchesFilter && task.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if tasks.isEmpty {
                    ContentUnavailableView(
                        "No Tasks",
                        systemImage: "checklist",
                        description: Text("Tap the + button to create a task")
                    )
                } else if filteredTasks.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    List {
                        ForEach(filteredTasks) { task in
                            TaskRowView(task: task) {
                                withAnimation {
                                    TaskViewModel(modelContext: modelContext)
                                        .toggleTaskCompletion(task)
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        TaskViewModel(modelContext: modelContext)
                                            .deleteTask(task)
                                    }
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
                            .listRowBackground(task.isCompleted ? Color(.systemGray6) : Color(.systemBackground))
                            .transition(.opacity.combined(with: .move(edge: .leading)))
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .searchable(text: $searchText, prompt: "Search tasks")
            .overlay(alignment: .bottom) {
                if !tasks.isEmpty {
                    HStack {
                        ForEach([TaskFilter.all, .active, .completed], id: \.title) { filter in
                            Button(action: { selectedFilter = filter }) {
                                Text(filter.title)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedFilter == filter ? Color.accentColor : Color.clear)
                                    .foregroundColor(selectedFilter == filter ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(8)
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 20)
                    )
                    .padding(.bottom, 8)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Tasks")
                        .font(.system(size: 28, weight: .bold))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                TaskFormView { title, dueDate, reminderDate, notes in
                    withAnimation {
                        TaskViewModel(modelContext: modelContext)
                            .addTask(
                                title: title,
                                dueDate: dueDate,
                                reminderDate: reminderDate,
                                notes: notes
                            )
                    }
                }
            }
            .sheet(item: $selectedTask) { task in
                TaskFormView(task: task) { title, dueDate, reminderDate, notes in
                    task.title = title
                    task.dueDate = dueDate
                    task.reminderDate = reminderDate
                    task.notes = notes
                    
                    withAnimation {
                        TaskViewModel(modelContext: modelContext)
                            .updateTask(task)
                    }
                }
            }
        }
    }
}
