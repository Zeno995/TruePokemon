//
//  NetworkProtocol.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Combine

/// A protocol defining network protocol capabilities
protocol NetworkProtocol {
  func perform<T: APIRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkError>
}

