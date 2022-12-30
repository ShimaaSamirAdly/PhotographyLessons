//
//  LessonsProvider.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation

enum LessonsProvider: NetworkApis {
    case getLessons
}

extension LessonsProvider {
    var baseURL: URL {
        return URL(string: "https://iphonephotographyschool.com/test-api")!
    }

    var path: String {
        switch self {
        case .getLessons:
            return "/lessons"
        }
    }

    var method: HttpMethods {
        switch self {
        case .getLessons:
            return .get
        }
    }

    var header: [String: String] {
        switch self {
        case .getLessons:
            return [:]
        }
    }
    var parameters: ParametersType {
        switch self {
        case .getLessons:
            return .requestPlain
        }
    }
}

