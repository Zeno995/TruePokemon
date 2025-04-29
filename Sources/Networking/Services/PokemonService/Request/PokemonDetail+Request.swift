//
//  PokemonDetail+Request.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

extension Networking.Service.Pokemon.Request {
  struct Detail: PokemonApiRequest {
    typealias Response = Model.Response.Pokemon.Detail
    let name: String
    var path: String { "/v2/pokemon/\(name)/" }
    var method: HTTPMethod { .get }
  }
}
