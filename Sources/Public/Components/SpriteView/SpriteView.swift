//
//  SpriteView.swift
//  TruePokemonSDK
//
//  Created by Enzo on 04/05/25.
//

import Nuke
import NukeUI
import SwiftUI

/// The `View` to show the Pokémon sprite from its name or image `URL`.
/// Usage example:
///
/// ```swift
/// SpriteView(name: "venusaur")
/// ```
///
/// or
///
/// ```swift
/// SpriteView(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png")!)
/// ```
public struct SpriteView: View {
  @StateObject private var viewModel: SpriteViewModel
  
  /// Creates the `View` to show the Pokémon sprite from its image `URL`.
  /// - Parameter url: The pokémon sprite `URL`.
  public init(url: URL) {
    self._viewModel = StateObject(wrappedValue: SpriteViewModel(url: url))
  }
  
  /// Creates the `View` to show the Pokémon sprite from its name.
  /// - Parameter name: The pokémon name.
  public init(name: String) {
    self._viewModel = StateObject(wrappedValue: SpriteViewModel(name: name))
  }
  
  public var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(Color(UIColor.secondarySystemBackground))
        .shadow(
          color: Color.black.opacity(0.1),
          radius: 4, x: 2, y: 2
        )
      
      content
        .padding(8)
    }
  }
  
  @ViewBuilder
  private var content: some View {
    switch viewModel.state {
    case let .loaded(url):
      LazyImage(url: url) { state in
        imageContent(state: state)
      }
      
    case .loading:
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
      
    case .error:
      Image("error", bundle: .module)
        .resizable()
        .scaledToFit()
    }
  }
  
  @ViewBuilder
  private func imageContent(state: any LazyImageState) -> some View {
    if state.isLoading {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
    } else if let image = state.image {
      image
        .resizable()
        .scaledToFit()
    } else {
      Image("error", bundle: .module)
        .resizable()
        .scaledToFit()
    }
  }
}
