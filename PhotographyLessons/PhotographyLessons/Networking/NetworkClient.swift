//
//  NetworkClient.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation
import Combine
import UIKit

class NetworkClient {
    static let shared = NetworkClient()

    private init() {}

    func callApiAsync<T: Codable>(target: NetworkApis, model: T.Type) async throws -> T? {
        if NetworkReachability.shared.isReachable() {
            return try await self.executeNetworkConnectionAsync(target: target, model: model)
        } else {
            throw ApiErrors.noInternet
        }
    }

    private func executeNetworkConnectionAsync<T: Codable>(target: NetworkApis, model: T.Type) async throws -> T? {
        let result = try await NetworkHandler.shared.requestAsync(target: target, model: model)
        return result as? T
    }
}
