//
//  GetLessonsUseCase.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation

struct GetLessonsUseCase {
    var repo: LessonsRepo
    
    func getLessons() async -> ([LessonModel], String) {
        let response = await repo.getLessons()
        return (response.0 ?? [], response.1)
    }
}
