//
//  AuthenticationRepositoryTests.swift
//  AxFTestAppTests
//
//  Created by Henry on 24/02/2023.
//

import Quick
import Nimble
import Foundation
@testable import AxFTestApp
@testable import ReactiveSwift

class AuthenticationRepositorySpec: QuickSpec {
    override func spec() {
        describe("Get Token Spec") {
            context("Given success response") {
                let expectedToken = "Access Token"
                let apiClient = MockAPIClient(statusCode: 200,
                                              dataResponse: [
                                                "\(APIResource.getToken)_post": """
                                                {"access_token": "\(expectedToken)"}
                                                """
                                              ],
                                              error: nil,
                                              responseTime: 1.0,
                                              performRandomResult: false)
                it("Result should contain accessToken") {
                    let authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl(apiClient: apiClient)
                    var token = ""
                    
                    waitUntil(timeout: DispatchTimeInterval.seconds(10)) { done in
                        authenticationRepository.getToken().startWithResult { result in
                            switch result {
                            case .success(let data):
                                token = data.data?.accessToken ?? ""
                                expect(token).to(equal(expectedToken))
                                break
                            case .failure(_):
                                fail("Should not fail")
                                break
                            }
                            
                            done()
                        }
                    }
                }
            }
            
            context("Given failed response") {
                let expectedError = "Get Token failed"
                let apiClient = MockAPIClient(statusCode: 200,
                                              dataResponse: [
                                                "\(APIResource.getToken)_post": """
                                                {"access_token": "\(expectedError)"}
                                                """
                                              ],
                                              error: APIError.error(expectedError),
                                              responseTime: 1.0,
                                              performRandomResult: false)
                it("Result should be failed") {
                    let authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl(apiClient: apiClient)
                    
                    waitUntil(timeout: DispatchTimeInterval.seconds(10)) { done in
                        authenticationRepository.getToken().startWithResult { result in
                            switch result {
                            case .success(_):
                                fail("Should not success")
                                break
                            case .failure(_):
                                break
                            }
                            
                            done()
                        }
                    }
                }
            }
        }
    }
}
