//
//  SearchView.swift
//  TruePokemonSampleApp
//
//  Created by Enzo on 29/04/25.
//

import SwiftUI

struct SearchView: View {
  @StateObject private var viewModel: SearchViewModel
  @EnvironmentObject var pokemonLayer: TruePokemonLayer
  
  init(viewModel: SearchViewModel = SearchViewModel()) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    VStack(spacing: 24) {
      Image("pokeball")
        .resizable()
        .scaledToFit()
        .frame(maxWidth: 250, maxHeight: 250)
        .padding(16)
      
      VStack(spacing: 8) {
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
        
        if let error = viewModel.errorMessage {
          Text(error)
            .foregroundStyle(Color.red)
            .font(.caption2)
        }
      }
      
      Button {
        viewModel.performSearch(pokemonLayer: pokemonLayer)
      } label: {
        if viewModel.isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
        } else {
          Text("Search")
            .padding(.horizontal, 8)
        }
      }
      .buttonStyle(.borderedProminent)
      .padding(.horizontal)
      .disabled(viewModel.isLoading)
      
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
