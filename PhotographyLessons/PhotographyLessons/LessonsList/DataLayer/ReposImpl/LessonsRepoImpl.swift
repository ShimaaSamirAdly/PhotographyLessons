//
//  LessonsRepoImpl.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation

struct LessonsRepoImpl: LessonsRepo {
    func getLessons() async -> ([LessonModel]?, String) {
        let lessonsResponse = await NetworkClient.shared.callApiAsync(target: LessonsProvider.getLessons, model: LessonsMainResponse.self)
        let lessons = lessonsResponse.0?.lessons?.map { LessonModel(id: $0.id ?? 0, name: $0.name ?? "", description: $0.description ?? "", lessonImg: $0.thumbnail ?? "", videoUrl: $0.videoUrl ?? "") }
        return (lessons, lessonsResponse.1)
    }
}
