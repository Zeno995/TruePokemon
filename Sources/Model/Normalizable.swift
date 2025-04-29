//
//  Normalizable.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

/// A protocol that normalize the API response.
/// `func normalizedForApp() -> model` serves as a bridge between models arriving from the API services
/// and models created for the app with the UI and app architecture in mind.
public protocol Normalizable {
  associatedtype NormalizedModel

  func normalizedForApp() -> NormalizedModel
}
