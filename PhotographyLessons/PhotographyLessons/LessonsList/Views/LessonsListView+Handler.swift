//
//  LessonsListView+Handler.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation
import CoreData
import Combine

extension LessonsListView {
    @MainActor
    class LessonsListViewHandler: ObservableObject {
        private var lessonsUseCase = GetLessonsUseCase(repo: LessonsRepoImpl())
        private var cacheLessonsUseCase = CacheLessonsUseCase(repo: LessonCachingRepoImpl())
        @Published var errorMsg = ""
        @Published var isLoading = false
        @Published var showCachedData = false
        @Published var isViewAppeared = true
        var cancellableSet = Set<AnyCancellable>()
        
        func getLessons() async -> [LessonModel] {
            isLoading = true
            let response = await lessonsUseCase.getLessons()
            isLoading = false
            switch response{
                case .success(let lessonsList):
                    let lessons = lessonsList
                    cacheLessonsUseCase.cachLessons(lessons: lessons)
                    return lessons
                case .failure(let error):
                    errorMsg = isViewAppeared ? error.errorDescription : ""
                    if error == .noInternet {
                        showCachedData = true
                    }
            }
            return []
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
