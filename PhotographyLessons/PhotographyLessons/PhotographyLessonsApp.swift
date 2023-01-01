//
//  PhotographyLessonsApp.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import SwiftUI

@main
struct PhotographyLessonsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var databaseManager = DatabaseManager.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                LessonsListView()
                    .environment(\.managedObjectContext, databaseManager.container.viewContext)
                    .navigationViewStyle(.stack)
            }
        }
    }
}
