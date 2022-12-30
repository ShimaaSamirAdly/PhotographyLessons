//
//  NetworkApisProtocol.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation

public protocol NetworkApis {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethods { get }
    var header: [String: String] { get }
    var parameters: ParametersType { get }
}

extension NetworkApis {
    var request: URLRequest {
        let targetUrl = self.baseURL.appendingPathComponent(self.path)
        var request = URLRequest(url: targetUrl)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = self.header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setRequestParameters(parametersType: parameters)
        request.timeoutInterval = 30
        return request
    }
}
