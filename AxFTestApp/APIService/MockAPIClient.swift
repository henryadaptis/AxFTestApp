//
//  MockAPIClient.swift
//  AxFTestApp
//
//  Created by Henry on 23/02/2023.
//

import Foundation
import ReactiveSwift

public final class MockAPIClient: APIClient {
    let maxRetry: Int
    let dataResponse: [String: String]
    let error: Error?
    let statusCode: Int
    let responseTime: Double
    let performRandomResult: Bool
    
    public init(statusCode: Int, dataResponse: [String: String], error: Error?, maxRetry: Int = 3, responseTime: Double, performRandomResult: Bool = true) {
        self.dataResponse = dataResponse
        self.error = error
        self.statusCode = statusCode
        self.maxRetry = maxRetry
        self.responseTime = responseTime
        self.performRandomResult = performRandomResult
    }
    
    func retry(_ times: Int, task: @escaping(@escaping () -> Void, @escaping (Error) -> Void) -> Void, success: @escaping () -> Void, failure: @escaping (Error) -> Void, onRetry: OnRetry?) {
        task(success,
             { error in
            if times > 0 {
                onRetry?(self.maxRetry - (times - 1))
                self.retry(times - 1, task: task, success: success, failure: failure, onRetry: onRetry)
            } else {
                failure(error)
            }
        })
    }
    
    private func _request(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        DispatchQueue(label: "com.axftest.request-queue", qos: .default, attributes: [.concurrent]).asyncAfter(deadline: .now() + self.responseTime) {
            let randomInt = Int.random(in: 0..<10)            
            let shouldThrowError = self.performRandomResult ? (randomInt < 5 && self.error != nil) : self.error != nil
            if shouldThrowError {
                failure(self.error!)
            } else {
                success()
            }
        }
    }
    
    public func request<T: Decodable>(url: String, method: HTTPMethod, headers: [String : String]?, data: Encodable?, onRetry: OnRetry?) -> SignalProducer<APIResponse<T>, Error> {
        return SignalProducer{ (observer, _) in
            self.retry(
                self.maxRetry,
                task: self._request,
                success: { [weak self] in
                    guard let self = self else {
                        observer.sendCompleted()
                        return
                    }
                    observer.send(value: APIResponse(data: T.map(JSONString: self.dataResponse["\(url)_\(method)"] ?? ""), error: self.error, statusCode: self.statusCode))
                    observer.sendCompleted()
                },
                failure: { error in
                    observer.send(error: error)
                    observer.sendCompleted()
                },
                onRetry: onRetry
            )
        }
    }
    
    public func upload<T: Decodable>(url: String, method: HTTPMethod, headers: [String : String]?, params: [String : String]?, media: Media,
                   onRetry: OnRetry?, onProgress: OnProgress?) -> SignalProducer<APIResponse<T>, Error> {
        return SignalProducer{ (observer, _) in
            self.retry(
                self.maxRetry,
                task: self._request,
                success: { [weak self] in
                    guard let self = self else {
                        observer.sendCompleted()
                        return
                    }
                    observer.send(value: APIResponse(data: T.map(JSONString: self.dataResponse["\(url)_\(method)"] ?? ""), error: self.error, statusCode: self.statusCode))
                    observer.sendCompleted()
                },
                failure: {error in
                    observer.send(error: error)
                    observer.sendCompleted()
                },
                onRetry: onRetry)
                        
        }
    }
}

let mockGetTokenResponse = """
    {"access_token": "token"}
"""

let mockUploadVideoResponse = """
    {"url": "videoUrl"}
"""
let mockUploadPhotoResponse = """
    {"url": "photoUrl"}
"""
