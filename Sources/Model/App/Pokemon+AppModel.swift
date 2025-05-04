//
//  Pokemon+AppModel.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

extension Model.App {
  /// The pokémon model.
  struct Pokemon: Equatable {
    let id: Int
    let name: String
    let description: String?
    let imageUrl: URL?
  }
}
