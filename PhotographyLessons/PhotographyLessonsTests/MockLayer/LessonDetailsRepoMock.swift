//
//  LessonDetailsRepoMock.swift
//  PhotographyLessonsTests
//
//  Created by Shimaa on 05/01/2023.
//

import Foundation
import Combine
@testable import PhotographyLessons

class DownloadRepoMockImpl: ObserveDownloadRepo {
    var isDownloading = false
    
    func observeDownloadProgress(forTaskUrl url: URL) async -> AnyPublisher<Double, Never>? {
        if isDownloading {
            return Just((0.5))
                .eraseToAnyPublisher()
        } else {
            return Just((0.0))
                .eraseToAnyPublisher()
        }
    }
}
