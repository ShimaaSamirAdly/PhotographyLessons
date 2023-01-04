//
//  LessonDetailsViewModel.swift
//  PhotographyLessons
//
//  Created by Shimaa on 31/12/2022.
//

import Foundation
import Combine

class LessonDetailsViewModel {
    private var lessonsList: [LessonModel] = []
    private var selectedLesson: LessonModel
    
    var showNextLessonPassThrough = PassthroughSubject<Void, Never>()
    var resetScreenPassThrough = PassthroughSubject<Void, Never>()
    var showProgressViewPassThrough = PassthroughSubject<Bool, Never>()
    var progressCountPassThrough = PassthroughSubject<Double, Never>()
    var cancellableSet = Set<AnyCancellable>()
    
    private let downloadLessonUseCase = DownloadLessonUseCase(repo: DownloadRepoImpl())
    private let cancelLessonUseCase = CancelLessonUseCase(repo: DownloadRepoImpl())
    private let checkLessonDownloading = CheckDownloadStateUseCase(repo: DownloadRepoImpl())
    private let observeProgressUseCase = ObserveDownloadProgress(repo: DownloadRepoImpl())
    
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
                self.checkIfLessonDownloading()
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
    
    func downloadLesson() {
        guard let videoUrl = URL(string: getLessonVideoUrl()) else { return }
        let lessonTitle = getLessonTitle()
        let downloadPublisher = downloadLessonUseCase.downloadLesson(withUrl: videoUrl, fileName: "\(lessonTitle).mp4")
        downloadPublisher.sink { [weak self] completion in
            guard let self = self else { return }
            self.showProgressViewPassThrough.send(false)
        } receiveValue: { url in
        }.store(in: &cancellableSet)
        checkIfLessonDownloading()
    }
    
    func cancelLessonDownloading() {
        Task { [weak self] in
            guard let self = self, let videoUrl = URL(string: getLessonVideoUrl()) else { return }
            await self.cancelLessonUseCase.cancelLessonDownloading(withUrl: videoUrl)
            self.checkIfLessonDownloading()
        }
    }
    
    func checkIfLessonDownloading() {
        Task { [weak self] in
            guard let self = self, let videoUrl = URL(string: getLessonVideoUrl()) else { return }
            let isDownloading = await self.checkLessonDownloading.isLessonDownloading(withUrl: videoUrl)
            self.showProgressViewPassThrough.send(isDownloading)
            if isDownloading {
                self.observeDownloadProgress()
            }
        }
    }
    
    func observeDownloadProgress() {
        Task { [weak self] in
            guard let self = self, let videoUrl = URL(string: getLessonVideoUrl()) else { return }
            await self.observeProgressUseCase.observeDownloadProgress(withUrl: videoUrl)?.sink(receiveValue: { progressValue in
                print(progressValue)
                if !progressValue.isNaN {
                    self.progressCountPassThrough.send(progressValue)
                }
            }).store(in: &self.cancellableSet)
        }
    }
}
