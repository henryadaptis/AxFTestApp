//
//  APIClient.swift
//  AxFTestApp
//
//  Created by Henry on 23/02/2023.
//

import Foundation
import ReactiveSwift

public struct APIResponse<T: Decodable> {
    public let data: T?
    public let error: Error?
    public let statusCode: Int
}

public enum APIError: Error {
    case error(String)
}

public enum HTTPMethod {
    case get
    case post
    case put
    case patch
    case delete
}

public typealias OnRetry = (_ count: Int) -> Void
public typealias OnProgress = (_ done: Double, _ total:Double) -> Void

public protocol APIClient {
    func request<T: Decodable>(url: String, method: HTTPMethod, headers: [String: String]?, data: Encodable?, onRetry: OnRetry?) -> SignalProducer<APIResponse<T>, Error>
    func upload<T: Decodable>(url: String, method: HTTPMethod, headers: [String: String]?, params: [String: String]?, media: Media,
                              onRetry: OnRetry?, onProgress: OnProgress?) -> SignalProducer<APIResponse<T>, Error>
}
