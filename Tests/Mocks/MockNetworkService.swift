//
//  MockNetworkService.swift
//  TruePokemonSampleApp
//
//  Created by Enzo on 30/04/25.
//  Copyright © 2025 EC. All rights reserved.
//

import Combine
import Foundation
@testable import TruePokemonSDK

class MockNetworkService: NetworkProtocol {
  var mockResponses: [String: String] = [:]
  var mockError: Error?
  
  func perform<T>(_ request: T) -> AnyPublisher<T.Response, NetworkError> where T : APIRequest {
    if let error = mockError {
      return Fail(error: NetworkError.unknown(error))
        .eraseToAnyPublisher()
    }
    
    let bundle = Bundle(for: MockNetworkService.self)
    let path = request.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    
    guard
      let responseJSONName = mockResponses[path],
      let url = bundle.url(forResource: responseJSONName, withExtension: "json")
    else {
      return Fail(error: NetworkError.invalidRequest)
        .eraseToAnyPublisher()
    }
    
    do {
      let data = try Data(contentsOf: url)
      let decoded = try JSONDecoder().decode(T.Response.self, from: data)
      return Just(decoded)
        .setFailureType(to: NetworkError.self)
        .eraseToAnyPublisher()
    } catch {
      return Fail(error: NetworkError.decodingFailed(error))
        .eraseToAnyPublisher()
    }
  }
  
  func clearCache() {}
}
