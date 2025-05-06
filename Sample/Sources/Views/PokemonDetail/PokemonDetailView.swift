//
//  PokemonDetailView.swift
//  TruePokemonSampleApp
//
//  Created by Enzo on 05/05/25.
//  Copyright © 2025 EC. All rights reserved.
//

import SwiftUI
import TruePokemonSDK

struct PokemonDetailView: View {
  @StateObject private var viewModel: PokemonDetailViewModel
  @Environment(\.dismiss) private var dismiss
  
  init(viewModel: PokemonDetailViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationView {
      content
        .toolbar {
          ToolbarItem(placement: .navigation) {
            Button {
              dismiss()
            } label: {
              Image(systemName: "xmark")
            }
          }
        }
    }
  }
  
  var content: some View {
    VStack(spacing: 24) {
      Text(viewModel.pokemonName)
        .font(.title)
        .fontWeight(.bold)
      
      SpriteView(name: viewModel.pokemonName)
        .frame(maxWidth: 250, maxHeight: 250)
        .padding(16)
      
      VStack(spacing: 16) {
        Text("Shakespeare description")
          .font(.title2)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        ShakespeareView(name: viewModel.pokemonName)
          .isColored(true)
          .isAnimated(true)
      }
      
      Spacer()
    }
    .padding(16)
  }
}

// MARK: – Preview

struct PokemonDetailView_Previews: PreviewProvider {
  static var previews: some View {
    PokemonDetailView(viewModel: PokemonDetailViewModel(pokemonName: "Ditto"))
  }
}
