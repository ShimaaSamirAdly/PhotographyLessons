//
//  DownloadRepoImpl.swift
//  PhotographyLessons
//
//  Created by Shimaa on 03/01/2023.
//

import Foundation
import Combine
import Photos

class DownloadRepoImpl: DownloadLessonRepo, CancelLessonRepo,
                        CheckDownloadStateRepo, ObserveDownloadRepo {
    func downloadFile(withUrl url: URL, fileName: String) -> AnyPublisher<URL, Error> {
        DownloadManager.shared.downloadFile(withUrl: url, fileName: fileName)
    }
    
    func cancelFileDownloading(withUrl url: URL) async {
        await DownloadManager.shared.cancelDownload(withUrl: url)
    }
    
    func checkIfDownloadRunning(forFileWithUrl url: URL) async -> Bool {
        await DownloadManager.shared.isDownloadRunning(forUrl: url)
    }
    
    func observeDownloadProgress(forTaskUrl url: URL) async -> AnyPublisher<Double, Never>? {
        await DownloadManager.shared.getProgressPublisher(forTaskUrl: url)
    }
}
