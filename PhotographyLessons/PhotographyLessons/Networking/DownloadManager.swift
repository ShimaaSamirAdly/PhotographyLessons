//
//  DownloadManager.swift
//  PhotographyLessons
//
//  Created by Shimaa on 02/01/2023.
//

import Foundation
import Combine
import Photos

class DownloadManager {
    static let shared = DownloadManager()
    private let currentTimePublisher = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
    private var cancellableSet = Set<AnyCancellable>()
    
    private init() { }
    
    func downloadFile(withUrl url: URL, fileName: String) -> AnyPublisher<URL, Error>  {
        Future<URL, Error> { [weak self] promise in
            guard let self = self else { return }
            let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
                if let localURL = localURL {
                    self.saveFileLocally(with: localURL, fileName: fileName)
                    promise(.success(localURL))
                } else if let error = error {
                    promise(.failure(error))
                }
                self.cancellableSet.removeAll()
            }
            task.resume()
        }.eraseToAnyPublisher()
    }
    
    func getProgressPublisher(forTaskUrl url: URL) async -> AnyPublisher<Double, Never>? {
        guard let task = await getTask(withUrl: url) else { return nil }
        let progressPublisher = PassthroughSubject<Double, Never>()
        setUpProgress(forTask: task, publisher: progressPublisher)
        return progressPublisher.eraseToAnyPublisher()
    }
    
    private func setUpProgress(forTask task: URLSessionTask, publisher: PassthroughSubject<Double, Never>) {
        currentTimePublisher
            .autoconnect()
            .sink { _ in
                let progress = Double(task.countOfBytesReceived) / Double(task.countOfBytesExpectedToReceive)
                publisher.send(progress)
        }.store(in: &cancellableSet)
       
    }
    
    func isDownloadRunning(forUrl url: URL) async -> Bool {
        guard let _ = await getTask(withUrl: url) else { return false }
        return true
    }
    
    func cancelDownload(withUrl url: URL) async {
        guard let task = await getTask(withUrl: url) else { return }
        task.cancel()
    }
    
    private func getTask(withUrl url: URL) async -> URLSessionTask? {
        let tasks = await URLSession.shared.tasks.2
        let task = tasks.first(where: { $0.originalRequest?.url == url })
        return task
    }
    
    func saveFileLocally(with localUrl: URL, fileName: String) {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(fileName)
        do {
           try FileManager.default.moveItem(at: localUrl, to: destinationUrl)
            PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                if authorizationStatus == .authorized {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationUrl)}) { completed, error in
                            if completed {
                                print("Success")
                            } else if let error = error {
                                print("failed \(error)")
                            }
                        }
                } else {
                    print("failed")
                }
            })
        } catch (let error) {
            print("failed \(error)")
        }
    }
}
