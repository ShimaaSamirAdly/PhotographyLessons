//
//  CancelLessonRepo.swift
//  PhotographyLessons
//
//  Created by Shimaa on 04/01/2023.
//

import Foundation

protocol CancelLessonRepo {
    func cancelFileDownloading(withUrl url: URL) async
}
