//
//  LessonsRepoImpl.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation

struct LessonsRepoImpl: LessonsRepo {
    func getLessons() async throws -> [LessonModel]? {
        let lessonsResponse = try await NetworkClient.shared.callApiAsync(target: LessonsProvider.getLessons, model: LessonsMainResponse.self)
        let lessons = lessonsResponse?.lessons?.map { LessonModel(id: $0.id ?? 0, name: $0.name ?? "", description: $0.description ?? "", lessonImg: $0.thumbnail ?? "", videoUrl: $0.videoUrl ?? "") }
        return lessons
    }
}
