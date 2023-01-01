//
//  Persistence.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import CoreData

class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    @Published var errorMsg = ""
    
    static var preview: DatabaseManager = {
        let result = DatabaseManager()
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Lesson(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container = NSPersistentContainer(name: "PhotographyLessons")

    private init() {
        container.loadPersistentStores(completionHandler: { [weak self] (storeDescription, error) in
            if let error = error {
                self?.errorMsg = "Unresolved error \(error.localizedDescription)"
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func addLesson(lesson: LessonModel) {
        let newLesson = Lesson(context: container.viewContext)
        newLesson.timestamp = Date()
        newLesson.id = Int32(lesson.id)
        newLesson.name = lesson.name
        newLesson.desc = lesson.description
        newLesson.videoUrl = lesson.videoUrl
        newLesson.lessonImg = lesson.lessonImg
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteAllLessons() {
        let fetchRequest = NSFetchRequest<Lesson>(entityName: "Lesson")
        do {
            let allLessons = try container.viewContext.fetch(fetchRequest)
            for lesson in allLessons {
                container.viewContext.delete(lesson)
            }
            try container.viewContext.save()
        } catch {
            print("errorrrrr ")
        }
    }
}
