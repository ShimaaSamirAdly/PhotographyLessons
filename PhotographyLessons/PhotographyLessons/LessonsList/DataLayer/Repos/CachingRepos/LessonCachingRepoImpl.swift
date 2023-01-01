//
//  LessonCachingRepoImpl.swift
//  PhotographyLessons
//
//  Created by Shimaa on 01/01/2023.
//

import Foundation

struct LessonCachingRepoImpl: LessonCachingRepo {

    func cashLessonsList(lessons: [LessonModel]) {
        DatabaseManager.shared.deleteAllLessons()
        for lesson in lessons {
            DatabaseManager.shared.addLesson(lesson: lesson)
        }
    }
}
