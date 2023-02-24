//
//  PostsRepository.swift
//  AxFTestApp
//
//  Created by Henry on 23/02/2023.
//

import Foundation
import ReactiveSwift

protocol PostsRepository {
    var apiClient: APIClient {get}
    func createPost(data: PostRequestModel) -> SignalProducer<PostModel, Error>
}

class PostsRepositoryImp: PostsRepository {
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func createPost(data: PostRequestModel) -> SignalProducer<PostModel, Error> {
        // Normally, this should be done inside APIClient. Since the project is simple, not yet define which routes need authorization.
        // So let inject headers here for simplification.
        guard let accessToken = SimpleDataStore.shared.accessToken else {
            return SignalProducer(error: APIError.error("Missing access token"))
        }
        let headers = [
            "Authorization": "Bearer \(accessToken)"
        ]
        let producer: SignalProducer<APIResponse<PostModel>, Error>  =
        apiClient.request(
            url: APIResource.createPost,
            method: .post,
            headers: headers,
            data: data,
            onRetry: nil
        )
        
        return producer.map { $0.data! }
    }
}
