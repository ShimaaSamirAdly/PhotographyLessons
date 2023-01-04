//
//  NetworkHandler.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation
import Combine

public class NetworkHandler {
    public static let shared = NetworkHandler()

    private init() { }

    public func requestAsync<T: Codable>(target: NetworkApis, model: T.Type) async throws
    -> Any? {
//        var error: ApiErrors = .none
//        var responseModel: Any?
        do {
            let result: (data: Data, response: URLResponse) = try await URLSession.shared.data(for: target.request)
            if let httpResponse = result.response as? HTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    let responseModel = try JSONDecoder().decode(T.self, from: result.data)
                    return responseModel
                } else {
                    let error = ApiErrors(rawValue: httpResponse.statusCode) ?? ApiErrors.none
//                    responseModel = try JSONDecoder().decode(MainResonseModel.self, from: result.data)
//                    return (responseModel, error)
                    throw error
                }
            }
        } catch {
            print("Failed connection")
            throw ApiErrors.badRequest
        }
//        return (responseModel, error)
        return nil
    }
}
