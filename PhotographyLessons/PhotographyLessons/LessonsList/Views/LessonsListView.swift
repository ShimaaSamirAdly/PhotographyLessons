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
         .onAppear {
             lessonsListHandler.isViewAppeared = true
         }.onDisappear {
             lessonsListHandler.isViewAppeared = false
         }
         .task {
            lessonsList = await lessonsListHandler.getLessons()
         }.errorAlert(error: $lessonsListHandler.errorMsg)
          .onChange(of: lessonsListHandler.showCachedData) { isShowCached in
              if isShowCached {
                  lessonsList = lessonsListHandler.getCachedLessons(cachedLessons: Array(cachedLessons))
              }
          }
    }
}


struct LessonsListView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsListView().environment(\.managedObjectContext, DatabaseManager.preview.container.viewContext)
    }
}
