//
//  MockAPIClient.swift
//  AxFTestApp
//
//  Created by Henry on 24/02/2023.
//

import Foundation

let authenticationAPIClient = MockAPIClient(statusCode: 200,
                                            dataResponse: [
                                                "\(APIResource.getToken)_post": mockGetTokenResponse
                                            ],
                                            error: APIError.error("Get Token failed"),
                                            responseTime: 1.0)

let uploadAPIClient = MockAPIClient(statusCode: 200,
                                    dataResponse: [
                                        "\(APIResource.uploadPhoto)_post": mockUploadPhotoResponse,
                                        "\(APIResource.uploadVideo)_post": mockUploadVideoResponse,
                                    ],
                                    error: APIError.error("Upload file failed"),
                                    responseTime: 1.0)

let postsAPIClient = MockAPIClient(statusCode: 200,
                                   dataResponse: [
                                    "\(APIResource.createPost)_post": """
                                                    {"id": "Nice work"}
                                                """
                                   ],
                                   error: APIError.error("Create post failed"),
                                   responseTime: 1.0)
