//
//  General.swift
//  AxFTestApp
//
//  Created by Henry on 23/02/2023.
//

import Foundation
import UIKit

// To simplify, assuming media is always in png format
public struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String

    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/png"
        self.fileName = "\(arc4random()).png"

        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.data = data
    }
}
