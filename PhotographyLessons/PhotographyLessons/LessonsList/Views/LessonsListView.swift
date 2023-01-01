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
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var lessonsList: [LessonModel] = []
    @StateObject private var lessonsListHandler = LessonsListViewHandler()

    var body: some View {
        ZStack {
            ProgressView()
                .isHidden(hidden: !(lessonsList.isEmpty && lessonsListHandler.isLoading), remove: true)
            List {
                ForEach(lessonsList, id: \.id) { lesson in
                    ZStack {
                        LessonRowView(lesson: lesson)
                        NavigationLink (destination: LessonDetailsView(lessonsList: lessonsList, selectedLesson: lesson)
                            .navigationBarTitleDisplayMode(.inline)) {}
                            .opacity(0)
                    }
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
    }


    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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
        LessonsListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
