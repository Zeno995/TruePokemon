//
//  APIRequest.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

/// A protocol that defines prerequisites to make an `APIRequest`.
protocol APIRequest {
  associatedtype Response: Decodable
  
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String] { get }
  var queryItems: [URLQueryItem]? { get }
  var body: Data? { get }
  var useCache: Bool { get }
  var cacheExpirationInterval: TimeInterval { get }
}

extension APIRequest {
  var body: Data? { nil }
  var useCache: Bool { true }
  var cacheExpirationInterval: TimeInterval { 3600 }
}
