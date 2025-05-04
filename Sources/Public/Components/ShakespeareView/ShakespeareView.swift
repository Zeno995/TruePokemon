//
//  ShakespeareView.swift
//  TruePokemon
//
//  Created by Enzo on 04/05/25.
//

import SwiftUI

/// The `View` to show the Shakespeare version of Pokémon description from its name.
/// Usage example:
///
/// ```swift
/// ShakespeareView(name: "venusaur")
/// ```
///
public struct ShakespeareView: View {
  @StateObject private var viewModel: ShakespeareViewModel
  
  /// Creates the `View` to show the Shakespeare version of Pokémon description.
  /// - Parameters:
  ///   - name: The pokémon name.
  ///   - isAnimated: Whether the view is animated or not.
  ///   - isColored: Whether the view is colored or not.
  public init(name: String, isAnimated: Bool = false, isColored: Bool = false) {
    self._viewModel = StateObject(wrappedValue: ShakespeareViewModel(name: name, isAnimated: isAnimated, isColored: isColored))
  }
  
  public var body: some View {
    ZStack {
      content
    }
    .animation(.easeInOut(duration: viewModel.isAnimated ? 0.5 : 0), value: viewModel.state)
    .padding()
  }
  
  @ViewBuilder
  private var content: some View {
    switch viewModel.state {
    case let .loaded(description):
      textContent(description)
      
    case .loading:
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
      
    case .error:
      Image("error", bundle: .module)
        .resizable()
        .scaledToFit()
    }
  }
  
  private func textContent(_ text: String) -> some View {
    Text(text)
      .foregroundColor(viewModel.isColored ? .white : .black)
      .padding()
      .background(textBackground)
      .cornerRadius(16)
      .overlay(textOverlay)
      .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
      .padding()
  }
  
  @ViewBuilder
  private var textBackground: some View {
    if viewModel.isColored {
      LinearGradient(
        gradient: Gradient(colors: [Color.purple, Color.blue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    } else {
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color(UIColor.secondarySystemBackground))
        .shadow(
          color: Color.black.opacity(0.1),
          radius: 4, x: 2, y: 2
        )
    }
  }
  
  @ViewBuilder
  private var textOverlay: some View {
    if viewModel.isColored {
      RoundedRectangle(cornerRadius: 16)
        .stroke(
          LinearGradient(
            gradient: Gradient(colors: [Color.white.opacity(0.6), Color.white.opacity(0.1)]),
            startPoint: .top,
            endPoint: .bottom
          ),
          lineWidth: 2
        )
    } else {
      EmptyView()
    }
  }
}
