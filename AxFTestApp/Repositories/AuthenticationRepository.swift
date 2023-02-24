//
//  AuthenticationRepository.swift
//  AxFTestApp
//
//  Created by Henry on 23/02/2023.
//

import Foundation
import ReactiveSwift

public protocol AuthenticationRepository {
    var apiClient: APIClient {get}
    func getToken() -> SignalProducer<APIResponse<LoginResponse>, Error>
}

public class AuthenticationRepositoryImpl: AuthenticationRepository {
    public let apiClient: APIClient
    
    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    public func getToken() -> SignalProducer<APIResponse<LoginResponse>, Error> {
        apiClient.request(url: APIResource.getToken, method: .post, headers: nil, data: nil, onRetry: nil)
    }
}
