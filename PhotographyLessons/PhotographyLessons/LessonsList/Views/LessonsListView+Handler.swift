//
//  LessonsListView+Handler.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation
import CoreData

extension LessonsListView {
    @MainActor
    class LessonsListViewHandler: ObservableObject {
        private var lessonsUseCase = GetLessonsUseCase(repo: LessonsRepoImpl())
        private var cacheLessonsUseCase = CacheLessonsUseCase(repo: LessonCachingRepoImpl())
        @Published var errorMsg = ""
        @Published var isLoading = false
        @Published var showCachedData = false
        @Published var newData = false
        
        func getLessons() async -> [LessonModel] {
            isLoading = true
            let response = await lessonsUseCase.getLessons()
            isLoading = false
            errorMsg = response.1
            let lessons = response.0
            cacheLessonsUseCase.cachLessons(lessons: lessons)
            showCachedData = lessons.isEmpty
            newData = !lessons.isEmpty
            return lessons
        }
        
        func getCachedLessons(cachedLessons: [Lesson]) -> [LessonModel] {
            let lessons = cachedLessons.map({
                LessonModel(id: Int($0.id), name: $0.name ?? "", description: $0.desc ?? "", lessonImg: $0.lessonImg ?? "", videoUrl: $0.videoUrl ?? "")
            })
            showCachedData = false
            return lessons
        }
    }
}
