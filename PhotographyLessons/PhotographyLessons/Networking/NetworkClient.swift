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
//            let errorMsg = handleErrors(error: .noInternet)
//            return (nil, errorMsg)
        }
    }

    private func executeNetworkConnectionAsync<T: Codable>(target: NetworkApis, model: T.Type) async throws -> T? {
        let result = try await NetworkHandler.shared.requestAsync(target: target, model: model)
//        if let error = result.error {
////            let errorMsg = handleErrors(error: result.error, errorModel: result.responseModel as? MainResonseModel)
////            return (nil, errorMsg)
//            throw error
//        }
        return result as? T
    }

//    private func handleErrors(error: ApiErrors?, errorModel: MainResonseModel? = nil) -> String {
//        guard let error = error else {
//            return ""
//        }
//        let errorMsg = errorModel?.message ?? error.errorDescription
//        return errorMsg
//    }
}
