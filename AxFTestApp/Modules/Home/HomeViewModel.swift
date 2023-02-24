//
//  HomeViewModel.swift
//  AxFTestApp
//
//  Created by Henry on 22/02/2023.
//

import Foundation
import ReactiveSwift
import Alamofire

struct PostActionInput {
    let content: String?
    let photo: Media?
    let photoParams: [String: String]?
    let video: Media?
    let videoParams: [String: String]?
}

class HomeViewModel {
    private let uploadRepository: UploadRepository
    private let postsRepository: PostsRepository
    private let authenticationRepository: AuthenticationRepository
    
    let loading: Property<Bool>
    let error: Signal<Error, Never>
    
    let createPostAction: Action<PostActionInput, PostModel, Error>
    
    let videoRetryCount: MutableProperty<Int?>
    let photoRetryCount: MutableProperty<Int?>
    
    init(authenticationRepository: AuthenticationRepository, uploadRepository: UploadRepository, postsRepository: PostsRepository) {
        self.uploadRepository = uploadRepository
        self.postsRepository = postsRepository
        self.authenticationRepository = authenticationRepository
        self.videoRetryCount = .init(nil)
        self.photoRetryCount = .init(nil)
        
        self.createPostAction = Action { [postsRepository, uploadRepository, authenticationRepository, videoRetryCount, photoRetryCount] postInput in
            authenticationRepository.getToken()
                .flatMap(.latest) { loginResponse in
                    if let accessToken = loginResponse.data?.accessToken {
                        SimpleDataStore.shared.accessToken = accessToken
                    }
                    return SignalProducer.combineLatest(
                        uploadRepository.uploadVideo(media: postInput.video!, params: postInput.videoParams, onRetry: { count in
                            videoRetryCount.value = count
                        }),
                        uploadRepository.uploadPhoto(media: postInput.photo!, params: postInput.photoParams, onRetry: { count in
                            photoRetryCount.value = count
                        })
                    )
                }
                .flatMap(.latest) { (video, photo) in
                    return postsRepository.createPost(data: PostRequestModel(content: postInput.content, videoUrl: video.url, imageUrl: photo.url))
                }
        }
        
        self.error = createPostAction.errors
        
        self.loading = .init(createPostAction.isExecuting)
    }
}
