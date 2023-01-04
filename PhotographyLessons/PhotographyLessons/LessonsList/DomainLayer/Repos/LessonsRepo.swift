//
//  LessonsRepo.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation

protocol LessonsRepo {
    func getLessons() async throws -> [LessonModel]?
}
