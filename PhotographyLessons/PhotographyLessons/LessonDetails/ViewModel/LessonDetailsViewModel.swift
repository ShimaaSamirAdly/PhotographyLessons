//
//  LessonDetailsViewModel.swift
//  PhotographyLessons
//
//  Created by Shimaa on 31/12/2022.
//

import Foundation
import Combine

class LessonDetailsViewModel {
    var lessonsList: [LessonModel] = []
    var selectedLesson: LessonModel
    
    var showNextLessonPassThrough = PassthroughSubject<Void, Never>()
    var resetScreenPassThrough = PassthroughSubject<Void, Never>()
    var cancellableSet = Set<AnyCancellable>()
    
    init(lessonsList: [LessonModel], selectedLesson: LessonModel) {
        self.lessonsList = lessonsList
        self.selectedLesson = selectedLesson
        setUpObservables()
    }
    
    func setUpObservables() {
        showNextLessonPassThrough.sink { [weak self] in
            guard let self = self else { return }
            if !self.isLastLesson() {
                self.setNextLesson()
            }
        }.store(in: &cancellableSet)
    }
    
    func getLessonVideoUrl() -> String {
        selectedLesson.videoUrl
    }
    
    func getLessonTitle() -> String {
        selectedLesson.name
    }
    
    func getLessonDesc() -> String {
        selectedLesson.description
    }
    
    func isLastLesson() -> Bool {
        selectedLesson.id == lessonsList.last?.id
    }
    
    func setNextLesson() {
        guard let currentLessonIndex = lessonsList.firstIndex(where: { $0.id == selectedLesson.id }) else {
            return
        }
        selectedLesson = lessonsList[currentLessonIndex + 1]
        resetScreenPassThrough.send(())
    }
}
