//
//  LessonDetailsViewModelMock.swift
//  PhotographyLessonsTests
//
//  Created by Shimaa on 05/01/2023.
//

import Foundation
@testable import PhotographyLessons

class LessonDetailsViewModelMock: LessonDetailsViewModel {
    
    var observeProgressUseCase: ObserveDownloadProgress?

    var progressCount = 0.0

    override func observeDownloadProgress() {
        Task { [weak self] in
            guard let self = self, let videoUrl = URL(string: getLessonVideoUrl()) else { return }
            await self.observeProgressUseCase?.observeDownloadProgress(withUrl: videoUrl)?
                .sink(receiveValue: { progressValue in
                print(progressValue)
                if !progressValue.isNaN {
                    self.progressCount = progressValue
                }
            }).store(in: &self.cancellableSet)
        }
    }
}
