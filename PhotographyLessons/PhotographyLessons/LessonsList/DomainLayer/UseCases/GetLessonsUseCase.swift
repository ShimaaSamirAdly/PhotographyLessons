//
//  GetLessonsUseCase.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation

struct GetLessonsUseCase {
    var repo: LessonsRepo
    
    func getLessons() async -> Result<[LessonModel], ApiErrors> {
        do {
            let response = try await repo.getLessons()
            return .success(response ?? [])
        } catch (let error) {
            if let error = error as? ApiErrors {
                return .failure(error)
            } else {
                return .failure(.badRequest)
            }
        }
    }
}
