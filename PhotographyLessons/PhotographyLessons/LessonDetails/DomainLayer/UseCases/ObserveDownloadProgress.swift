//
//  ObserveDownloadProgress.swift
//  PhotographyLessons
//
//  Created by Shimaa on 04/01/2023.
//

import Foundation
import Combine

struct ObserveDownloadProgress {
    var repo: ObserveDownloadRepo
    
    func observeDownloadProgress(withUrl url: URL) async -> AnyPublisher<Double, Never>? {
        await repo.observeDownloadProgress(forTaskUrl: url)
    }
}

