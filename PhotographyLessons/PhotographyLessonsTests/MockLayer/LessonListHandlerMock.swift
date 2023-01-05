//
//  LessonListHandlerMock.swift
//  PhotographyLessonsTests
//
//  Created by Shimaa on 05/01/2023.
//

import Foundation
@testable import PhotographyLessons

class LessonListHandlerMock: LessonsListView.LessonsListViewHandler {
    
    var useCase: GetLessonsUseCase?
    var callCacheLessons = false
    
    override func getLessons() async -> [LessonModel] {
        let response = await useCase?.getLessons()
        switch response{
            case .success(let lessonsList):
                let lessons = lessonsList
                callCacheLessons = true
                return lessons
            case .failure(let error):
                errorMsg = error.errorDescription
                if error == .noInternet {
                    showCachedData = true
                }
            case .none:
                return []
        }
        return []
    }
}
