//
//  LessonRepoMockImpl.swift
//  PhotographyLessonsTests
//
//  Created by Shimaa on 05/01/2023.
//

import Foundation
@testable import PhotographyLessons

struct LessonRepoMockImpl: LessonsRepo {
    var noInternet = false
    
    func getLessons() async throws -> [PhotographyLessons.LessonModel]? {
        if noInternet {
            throw ApiErrors.noInternet
        } else {
            return [LessonModel(id: 0, name: "", description: "", lessonImg: "", videoUrl: "")]
        }
    }
    
    
}
