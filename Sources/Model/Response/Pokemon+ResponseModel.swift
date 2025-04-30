//
//  Pokemon+ResponseModel.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

extension Model.Response {
  /// The pokémon response model, used both to merge all API responses and to parse
  /// the search API response.
  struct Pokemon: Decodable {
    let detail: Model.Response.Pokemon.Detail
    let species: Model.Response.Pokemon.Species
  }
}

// MARK: - Normalization

extension Model.Response.Pokemon: Normalizable {
  func normalizedForApp() -> Model.App.Pokemon {
    Model.App.Pokemon(
      id: detail.id,
      name: detail.name,
      description: species.flavorTextEntries.first(where: { $0.languageName == "en" })?.text,
      imageUrl: URL(string: detail.sprites.frontDefault)
    )
  }
}
