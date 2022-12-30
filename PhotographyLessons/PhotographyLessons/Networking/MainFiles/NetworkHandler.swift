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

    public func requestAsync<T: Codable>(target: NetworkApis, model: T.Type) async
    -> (responseModel: Any?, error: ApiErrors?) {
        var error: ApiErrors?
        var responseModel: Any?
        do {
            let result: (data: Data, response: URLResponse) = try await URLSession.shared.data(for: target.request)
            if let httpResponse = result.response as? HTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    responseModel = try JSONDecoder().decode(T.self, from: result.data)
                } else {
                    error = ApiErrors(rawValue: httpResponse.statusCode) ?? ApiErrors.none
                    responseModel = try JSONDecoder().decode(MainResonseModel.self, from: result.data)
                    return (responseModel, error)
                }
            }
        } catch {
            print("Failed connection")
        }
        return (responseModel, error)
    }
}
