//
//  PokemonApiRequest.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

protocol PokemonApiRequest: APIRequest {}

extension PokemonApiRequest {
  var baseURL: String { "https://pokeapi.co/api" }
  var queryItems: [URLQueryItem]? { nil }
  var headers: [String: String] {
    ["Content-Type": "application/json"]
  }
}
