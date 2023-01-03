//
//  CheckDownloadStateUseCase.swift
//  PhotographyLessons
//
//  Created by Shimaa on 03/01/2023.
//

import Foundation

struct CheckDownloadStateUseCase {
    var repo: CheckDownloadStateRepo
    
    func isLessonDownloading(withUrl url: URL) async -> Bool {
        await repo.checkIfDownloadRunning(forFileWithUrl: url)
    }
}
