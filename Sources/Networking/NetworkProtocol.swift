//
//  NetworkProtocol.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Combine

/// A protocol defining network protocol capabilities.
protocol NetworkProtocol {
  /// Perform a network request.
  /// - Parameter request: The request conforms to `APIRequest`.
  /// - Returns: A `AnyPublisher` containing the response model or the `NetworkError`.
  func perform<T: APIRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkError>
  
  /// Clear all cache.
  func clearCache()
}

