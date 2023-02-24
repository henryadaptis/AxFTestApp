//
//  UploadRepository.swift
//  AxFTestApp
//
//  Created by Henry on 23/02/2023.
//

import Foundation
import ReactiveSwift

protocol UploadRepository {
    var apiClient: APIClient {get}
    func uploadPhoto(media: Media, params: [String: String]?, onRetry: OnRetry?) -> SignalProducer<UploadFileResponse, Error>
    func uploadVideo(media: Media, params: [String: String]?, onRetry: OnRetry?) -> SignalProducer<UploadFileResponse, Error>
}

class UploadRepositoryImpl: UploadRepository {
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func uploadPhoto(media: Media, params: [String: String]?, onRetry: OnRetry?) -> SignalProducer<UploadFileResponse, Error> {
        // Normally, this should be done inside APIClient. Since the project is simple, not yet define which routes need authorization.
        // So let inject headers here for simplification.
        guard let accessToken = SimpleDataStore.shared.accessToken else {
            return SignalProducer(error: APIError.error("Missing access token"))
        }
        let headers = [
            "Authorization": "Bearer \(accessToken)"
        ]
        let producer: SignalProducer<APIResponse<UploadFileResponse>, Error> =
        apiClient.upload(url: APIResource.uploadPhoto,
                         method: .post,
                         headers: headers,
                         params: params,
                         media: media,
                         onRetry: onRetry,
                         onProgress: nil
        )
        
        return producer.map { $0.data! }
    }
    
    func uploadVideo(media: Media, params: [String: String]?, onRetry: OnRetry?) -> SignalProducer<UploadFileResponse, Error> {
        // Normally, this should be done inside APIClient. Since the project is simple, not yet define which routes need authorization.
        // So let inject headers here for simplification.
        guard let accessToken = SimpleDataStore.shared.accessToken else {
            return SignalProducer(error: APIError.error("Missing access token"))
        }
        let headers = [
            "Authorization": "Bearer \(accessToken)"
        ]
        let producer: SignalProducer<APIResponse<UploadFileResponse>, Error> =
        apiClient.upload(url: APIResource.uploadVideo,
                         method: .post,
                         headers: headers,
                         params: params,
                         media: media,
                         onRetry: onRetry,
                         onProgress: nil
        )
        
        return producer.map { $0.data! }
    }
    
    
}
