//
//  LessonsResponse.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation

struct LessonsResponse: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: String?
    var videoUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail
        case videoUrl = "video_url"
    }
}
