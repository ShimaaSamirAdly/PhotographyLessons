//
//  DownloadLessonUseCase.swift
//  PhotographyLessons
//
//  Created by Shimaa on 03/01/2023.
//

import Foundation
import Combine

struct DownloadLessonUseCase {
    var repo: DownloadLessonRepo
    
    func downloadLesson(withUrl url: URL) -> AnyPublisher<URL, Error> {
        repo.downloadFile(withUrl: url)
    }
}
