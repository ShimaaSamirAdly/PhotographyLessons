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
    
    func downloadLesson(withUrl url: URL, fileName: String) -> AnyPublisher<URL, Error> {
        repo.downloadFile(withUrl: url, fileName: fileName)
    }
}
