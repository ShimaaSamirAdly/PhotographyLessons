//
//  DownloadLessonRepo.swift
//  PhotographyLessons
//
//  Created by Shimaa on 04/01/2023.
//

import Foundation
import Combine

protocol DownloadLessonRepo {
    func downloadFile(withUrl url: URL) -> AnyPublisher<URL, Error>
}
