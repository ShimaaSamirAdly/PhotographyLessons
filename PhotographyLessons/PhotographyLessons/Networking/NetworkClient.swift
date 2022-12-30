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

    func callApiAsync<T: Codable>(target: NetworkApis, model: T.Type) async -> (T?, String) {
        if NetworkReachability.shared.isReachable() {
            return await self.executeNetworkConnectionAsync(target: target, model: model)
        } else {
            let errorMsg = handleErrors(error: .noInternet)
            return (nil, errorMsg)
        }
    }

    private func executeNetworkConnectionAsync<T: Codable>(target: NetworkApis, model: T.Type) async -> (T?, String) {
        let result = await NetworkHandler.shared.requestAsync(target: target, model: model)
        if result.error != nil {
            let errorMsg = handleErrors(error: result.error, errorModel: result.responseModel as? MainResonseModel)
            return (nil, errorMsg)
        }
        return (result.responseModel as? T, "")
    }

    private func handleErrors(error: ApiErrors?, errorModel: MainResonseModel? = nil) -> String {
        guard let error = error else {
            return ""
        }
        let errorMsg = errorModel?.message ?? error.errorDescription
        return errorMsg
    }
}
