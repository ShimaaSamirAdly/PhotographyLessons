//
//  LessonsListView.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import SwiftUI
import CoreData

struct LessonsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Lesson.timestamp, ascending: true)],
        animation: .default)
    private var cachedLessons: FetchedResults<Lesson>
    @State private var lessonsList: [LessonModel] = []
    @StateObject private var lessonsListHandler = LessonsListViewHandler()

    var body: some View {
        ZStack {
            ProgressView()
                .isHidden(hidden: !(lessonsList.isEmpty && lessonsListHandler.isLoading), remove: true)
            List(lessonsList, id: \.id) { lesson in
                ZStack {
                    LessonRowView(lesson: lesson)
                    NavigationLink (destination: LessonDetailsView(lessonsList: lessonsList, selectedLesson: lesson)
                        .navigationBarTitleDisplayMode(.inline)) {}
                        .opacity(0)
                }
            }.listStyle(.plain)
             .isHidden(hidden: lessonsList.isEmpty && lessonsListHandler.isLoading, remove: true)
             .refreshable {
                lessonsList = await lessonsListHandler.getLessons()
             }.redacted(reason: lessonsListHandler.isLoading ? .placeholder : [])
        }.navigationTitle("Lessons")
         .task {
            lessonsList = await lessonsListHandler.getLessons()
         }.errorAlert(error: $lessonsListHandler.errorMsg)
          .onChange(of: lessonsListHandler.showCachedData) { isShowCached in
            if isShowCached {
                lessonsList = lessonsListHandler.getCachedLessons(cachedLessons: Array(cachedLessons))
            }
          }
    }

    private func addItem() {
        deleteItems()
        for lesson in lessonsList {
            withAnimation {
                let newLesson = Lesson(context: viewContext)
                newLesson.timestamp = Date()
                newLesson.id = Int32(lesson.id)
                newLesson.name = lesson.name
                newLesson.desc = lesson.description
                newLesson.videoUrl = lesson.videoUrl
                newLesson.lessonImg = lesson.lessonImg

                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
        
    }

    private func deleteItems() {
        withAnimation {
            cachedLessons.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


struct LessonsListView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsListView().environment(\.managedObjectContext, DatabaseManager.preview.container.viewContext)
    }
}
