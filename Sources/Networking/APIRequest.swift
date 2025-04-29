//
//  APIRequest.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

protocol APIRequest {
  associatedtype Response: Decodable
  
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String] { get }
  var queryItems: [URLQueryItem]? { get }
  var body: Data? { get }
}

extension APIRequest {
  var headers: [String: String] {
    ["Content-Type": "application/json"]
  }
  var queryItems: [URLQueryItem]? { nil }
  var body: Data? { nil }
}
