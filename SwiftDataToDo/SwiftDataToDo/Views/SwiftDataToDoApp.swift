//
//  SwiftDataToDoApp.swift
//  SwiftDataToDo
//
//  Created by vishva narola on 10/06/25.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataToDoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Task.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
        
        // Request notification permissions when app launches
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
        .modelContainer(container)
    }
}
