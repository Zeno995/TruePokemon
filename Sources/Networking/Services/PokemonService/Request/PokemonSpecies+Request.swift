//
//  PokemonSpecies+Request.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

extension Networking.Service.Pokemon.Request {
  /// The request to retrive the pokémon species from its identifier.
  struct Species: PokemonApiRequest {
    typealias Response = Model.Response.Pokemon.Species
    let id: Int
    var path: String { "/v2/pokemon-species/\(id)/" }
    var method: HTTPMethod { .get }
  }
}
