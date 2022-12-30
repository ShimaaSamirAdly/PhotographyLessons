//
//  PhotographyLessonsApp.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import SwiftUI

@main
struct PhotographyLessonsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
