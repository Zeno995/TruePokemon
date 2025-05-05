//
//  SearchViewModel.swift
//  TruePokemonSampleApp
//
//  Created by Enzo on 05/05/25.
//  Copyright © 2025 EC. All rights reserved.
//

import SwiftUI

class SearchViewModel: ObservableObject {
  @Published var query: String = ""
  @Published var pokemonDetailViewModel: PokemonDetailViewModel?
  
  func performSearch() {
    guard !query.isEmpty else {
      return
    }
    
    pokemonDetailViewModel = PokemonDetailViewModel(pokemonName: query)
  }
  
  func clearText() {
    query = ""
  }
}
