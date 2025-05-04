//
//  ShakespeareServiceProtocol.swift
//  TruePokemonSDK
//
//  Created by Enzo on 30/04/25.
//

import Combine

extension Networking.Service {
  /// Protocol that defines network operations related to the Shakespeare API.
  protocol ShakespeareProtocol {
    /// Fetches a shakespeare version from text.
    /// - Parameter text: The text to translate.
    /// - Returns: The shakespeare object.
    /// - Throws: NetworkError if the request fails.
    func description(from text: String) -> AnyPublisher<Model.App.Shakespeare.Translate, ServiceError>
  }
}
