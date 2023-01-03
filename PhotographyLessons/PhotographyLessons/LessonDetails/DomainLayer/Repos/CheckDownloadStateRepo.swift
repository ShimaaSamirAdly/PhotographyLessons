//
//  CheckDownloadStateRepo.swift
//  PhotographyLessons
//
//  Created by Shimaa on 04/01/2023.
//

import Foundation

protocol CheckDownloadStateRepo {
    func checkIfDownloadRunning(forFileWithUrl url: URL) async -> Bool
}
