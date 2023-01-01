//
//  CacheLessonsUseCase.swift
//  PhotographyLessons
//
//  Created by Shimaa on 01/01/2023.
//

import Foundation

struct CacheLessonsUseCase {
    var repo: LessonCachingRepo
    
    func cachLessons(lessons: [LessonModel]) {
        if !lessons.isEmpty {
            repo.cashLessonsList(lessons: lessons)
        }
    }
}
