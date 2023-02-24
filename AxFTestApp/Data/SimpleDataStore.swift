//
//  SimpleDataStore.swift
//  AxFTestApp
//
//  Created by Henry on 24/02/2023.
//

import Foundation

class SimpleDataStore {
    static let shared = SimpleDataStore()
    
    var accessToken: String?
    
    private init() {}
}
