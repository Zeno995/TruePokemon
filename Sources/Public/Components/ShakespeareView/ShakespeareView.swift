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
  let isAnimated: Bool
  let isColored: Bool
  let name: String
  
  @StateObject private var viewModel: ShakespeareViewModel
  
  /// Creates the `View` to show the Shakespeare version of Pokémon description.
  /// - Parameters:
  ///   - name: The pokémon name.
  ///   - isAnimated: Whether the view is animated or not.
  ///   - isColored: Whether the view is colored or not.
  public init(name: String) {
    self._viewModel = StateObject(wrappedValue: ShakespeareViewModel(name: name))
    self.isAnimated = false
    self.isColored = false
    self.name = name
  }
  
  private init(name: String, isAnimated: Bool = false, isColored: Bool = false) {
    self._viewModel = StateObject(wrappedValue: ShakespeareViewModel(name: name))
    self.isAnimated = isAnimated
    self.isColored = isColored
    self.name = name
  }
  
  public var body: some View {
    ZStack {
      content
    }
    .animation(.easeInOut(duration: isAnimated ? 0.5 : 0), value: viewModel.state)
  }
  
  @ViewBuilder
  private var content: some View {
    switch viewModel.state {
    case let .loaded(description):
      textContent(description)
      
    case .loading:
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
      
    case let .error(error):
      Text(error.localizedDescription)
        .foregroundColor(.red)
        .multilineTextAlignment(.center)
    }
  }
  
  private func textContent(_ text: String) -> some View {
    Text(text)
      .foregroundColor(isColored ? .white : .black)
      .padding()
      .background(textBackground)
      .cornerRadius(16)
      .overlay(textOverlay)
      .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
  }
  
  @ViewBuilder
  private var textBackground: some View {
    if isColored {
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
    if isColored {
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
  
  /// Builder function to enable or disable animations.
  /// - Parameter animated: Whether the view is animated or not.
  /// - Returns: A new `ShakespeareView` configured for animation.
  public func isAnimated(_ animated: Bool) -> ShakespeareView {
    ShakespeareView(
      name: name,
      isAnimated: animated,
      isColored: isColored
    )
  }
  
  /// Builder function to enable or disable coloring.
  /// - Parameter colored: Whether the view is colored or not.
  /// - Returns: A new `ShakespeareView` configured for coloring.
  public func isColored(_ colored: Bool) -> ShakespeareView {
    ShakespeareView(
      name: name,
      isAnimated: isAnimated,
      isColored: colored
    )
  }
}
