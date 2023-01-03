//
//  CancelLessonUseCase.swift
//  PhotographyLessons
//
//  Created by Shimaa on 03/01/2023.
//

import Foundation

struct CancelLessonUseCase {
    var repo: CancelLessonRepo
    
    func cancelLessonDownloading(withUrl url: URL) async {
        await repo.cancelFileDownloading(withUrl: url)
    }
}
