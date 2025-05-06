//
//  SearchViewModel.swift
//  TruePokemonSampleApp
//
//  Created by Enzo on 05/05/25.
//  Copyright © 2025 EC. All rights reserved.
//

import SwiftUI
import TruePokemonSDK

class SearchViewModel: ObservableObject {
  @Published var query: String = "" {
    didSet {
      if query != oldValue {
        errorMessage = nil
      }
    }
  }
  
  @Published var errorMessage: String? = nil {
    didSet {
      if errorMessage != nil {
        isLoading = false
      }
    }
  }
  
  @Published var pokemonDetailViewModel: PokemonDetailViewModel?
  @Published var isLoading = false
  
  func performSearch(pokemonLayer: TruePokemonLayer) {
    guard !query.isEmpty else {
      return
    }
    
    isLoading = true
    Task { @MainActor in
      do {
        guard try await pokemonLayer.verifyPokemon(from: query) else {
          errorMessage = "Pokemon not found"
          return
        }
        
        pokemonDetailViewModel = PokemonDetailViewModel(pokemonName: query)
        isLoading = false
      } catch {
        guard let truePokemonError = error as? TruePokemonSDKError else {
          errorMessage = "Unaspected error"
          return
        }
        
        errorMessage = truePokemonError.localizedDescription
      }
    }
  }
  
  func clearText() {
    query = ""
  }
}
