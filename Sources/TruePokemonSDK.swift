//
//  HTTPMethod.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Combine
import Foundation

public struct TruePokemonSDK {
  public init() {}
  
  public func getPokemon() -> AnyPublisher<Model.App.Pokemon, TruePokemonSDKError> {
    Networking.Service.Pokemon(networkService: NetworkService())
      .detail(from: "ditto")
      .mapError { _ in TruePokemonSDKError.unknown }
      .eraseToAnyPublisher()
  }
}
