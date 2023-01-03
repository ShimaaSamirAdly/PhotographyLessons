//
//  ObserveDownloadRepo.swift
//  PhotographyLessons
//
//  Created by Shimaa on 04/01/2023.
//

import Foundation
import Combine

protocol ObserveDownloadRepo {
    func observeDownloadProgress(forTaskUrl url: URL) async -> AnyPublisher<Double, Never>?
}
