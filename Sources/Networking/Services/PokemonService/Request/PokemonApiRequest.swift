//
//  PokemonApiRequest.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

protocol PokemonApiRequest: APIRequest {}

extension PokemonApiRequest {
  var baseURL: String { "https://pokeapi.co/api" }
}

