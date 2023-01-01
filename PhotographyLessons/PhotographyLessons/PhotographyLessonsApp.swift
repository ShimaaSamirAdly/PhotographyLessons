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
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                LessonsListView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
