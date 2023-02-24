## Installation
- pod install
- Run project

## Usage
Notes: All data are mocked, and default behauvior is randomly throw error during the execution.

- To change the default behauvior, follow these steps
1. Locate file "MockAPIClientHelper.swift" under "Helper" folder
2. Update "performRandomResult" to false. If "error" is not nil, error will be thrown. 
Example
```swift
// Swift

let authenticationAPIClient = MockAPIClient(statusCode: 200,
                                            dataResponse: [
                                                "\(APIResource.getToken)_post": mockGetTokenResponse
                                            ],
                                            error: APIError.error("Get Token failed"),
                                            responseTime: 1.0,
                                            performRandomResult: false)
```
3. Rerun the project