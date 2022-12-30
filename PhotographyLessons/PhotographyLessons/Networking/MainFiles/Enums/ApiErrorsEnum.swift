//
//  ApiErrorsEnum.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation

public enum ApiErrors: Int, Error {
    case badRequest = 400              // Possibly the parameters are invalid
    case invalidCredential = 401       // INVALID CREDENTIAL, possible invalid token
    case notFound = 404              // The item you looked for is not found
    case serverError = 500             // Error from Server
    case unprocessableEntity = 422
    case forbidden = 403
    case noInternet = 0
    case none

    var errorDescription: String {
        switch self {
        case .badRequest:
            return "badRequest"
        case .notFound:
            return "notFound"
        case .serverError:
            return "serverError"
        case .invalidCredential:
            return "invalidCredential"
        case .unprocessableEntity:
            return "unprocessableEntity"
        case .forbidden:
            return "forbidden"
        case .noInternet:
            return "No Internet Connection"
        default:
            return ""
        }
    }
}
