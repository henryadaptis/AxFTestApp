//
//  Post.swift
//  AxFTestApp
//
//  Created by Henry on 23/02/2023.
//

import Foundation

struct PostRequestModel: Encodable {
    let content: String?
    let videoUrl: String?
    let imageUrl: String?
}

public struct PostModel: Decodable {
    let id: String    
}
