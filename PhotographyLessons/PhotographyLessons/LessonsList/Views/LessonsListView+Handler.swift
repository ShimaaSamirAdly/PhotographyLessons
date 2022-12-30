//
//  LessonsListView+Handler.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation

extension LessonsListView {
    @MainActor
    class LessonsListViewHandler: ObservableObject {
        private var lessonsUseCase = GetLessonsUseCase(repo: LessonsRepoImpl())
        @Published var errorMsg = ""
        @Published var isLoading = false
       
        func getLessons() async -> [LessonModel] {
            isLoading = true
            let response = await lessonsUseCase.getLessons()
            isLoading = false
            errorMsg = response.1
            return response.0
        }
    }
}
