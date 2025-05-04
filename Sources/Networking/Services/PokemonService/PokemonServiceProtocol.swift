//
//  PokemonServiceProtocol.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Combine

extension Networking.Service {
  /// Protocol that defines network operations related to the Pokémon API.
  protocol PokemonProtocol {
    /// Fetches a pokémon detail from its name.
    /// - Parameter name: The name of the pokémon.
    /// - Returns: The pokémon detail.
    /// - Throws: NetworkError if the request fails.
    func detail(from name: String) -> AnyPublisher<Model.App.Pokemon, ServiceError>
  }
}
