//
//  Pokemon+AppModel.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

public extension Model.App {
  /// The pokémon model.
  struct Pokemon: Equatable {
    public let id: Int
    public let name: String
    public let description: String?
    public let imageUrl: URL?
  }
}
