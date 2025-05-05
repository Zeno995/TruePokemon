//
//  SearchView.swift
//  TruePokemonSampleApp
//
//  Created by Enzo on 29/04/25.
//

import SwiftUI

struct SearchView: View {
  @StateObject private var viewModel = SearchViewModel()
  
  var body: some View {
    VStack(spacing: 24) {
      Image("pokeball")
        .resizable()
        .scaledToFit()
        .frame(maxWidth: 250, maxHeight: 250)
        .padding(16)
      
      HStack {
        Image(systemName: "magnifyingglass")
        
        TextField("Search pokémon...", text: $viewModel.query)
          .disableAutocorrection(true)
          .textFieldStyle(PlainTextFieldStyle())
        
        if !viewModel.query.isEmpty {
          Button(action: viewModel.clearText) {
            Image(systemName: "xmark.circle.fill")
          }
        }
      }
      .padding(12)
      .background(Color(.secondarySystemBackground))
      .cornerRadius(16)
      .padding(.horizontal)
      
      Button(action: viewModel.performSearch) {
        Text("Search")
          .padding(.horizontal, 8)
      }
      .buttonStyle(.borderedProminent)
      .padding(.horizontal)
      
      Spacer()
    }
    .fullScreenCover(item: $viewModel.pokemonDetailViewModel) { viewModel in
      PokemonDetailView(viewModel: viewModel)
    }
  }
}

// MARK: – Preview

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView()
  }
}
