//
//  Decodable.swift
//  AxFTestApp
//
//  Created by Henry on 24/02/2023.
//

import Foundation

extension Decodable {
    static func map(JSONString:String) -> Self? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Self.self, from: Data(JSONString.utf8))
        } catch let error {
            print(error)
            return nil
        }
    }
}
