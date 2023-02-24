//
//  Alamofire+Extensions.swift
//  AxFTestApp
//
//  Created by Henry on 23/02/2023.
//

import Foundation
import Alamofire
import ReactiveSwift

extension DataRequest: ReactiveExtensionsProvider {}

extension Reactive where Base: DataRequest {        
    @discardableResult
    func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil) -> SignalProducer<T?, AFError> {
        return SignalProducer{ (observer, disposable) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = self.base.responseDecodable(of: T.self,
                                                       queue: queue ?? DispatchQueue(label: "com.axftest.response-queue", qos: .utility, attributes: [.concurrent]),
                                                       decoder: decoder,
                                                       completionHandler: { data in
                if let error = data.error {
                    observer.send(error: error)
                } else {
                    observer.send(value: data.value)
                }
                observer.sendCompleted()
            })
            
            disposable.observeEnded {
                response.cancel()
            }
        }
    }
}

extension Session: ReactiveExtensionsProvider {}

extension Reactive where Base: Session {
    @discardableResult
    func upload<T: Decodable>(formData: MultipartFormData, to: URLConvertible, queue: DispatchQueue? = nil) -> SignalProducer<T?, AFError> {
        return SignalProducer { (observer, disposable) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = self.base
                .upload(multipartFormData: formData, to: to)
                .responseDecodable(of: T.self,
                                   queue: queue ?? DispatchQueue(label: "com.axftest.response-queue", qos: .utility, attributes: [.concurrent]),
                                   decoder: decoder,
                                   completionHandler: { data in
                    if let error = data.error {
                        observer.send(error: error)
                    } else {
                        observer.send(value: data.value)
                    }
                    observer.sendCompleted()
                })
            
            disposable.observeEnded {
                response.cancel()
            }
        }
    }
}
