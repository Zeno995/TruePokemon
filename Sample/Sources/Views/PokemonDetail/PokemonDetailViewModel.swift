//
//  PokemonDetailViewModel.swift
//  TruePokemonSampleApp
//
//  Created by Enzo on 05/05/25.
//  Copyright © 2025 EC. All rights reserved.
//

import SwiftUI

class PokemonDetailViewModel: ObservableObject, Identifiable {
  let pokemonName: String
  
  init(pokemonName: String) {
    self.pokemonName = pokemonName
  }
}
