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
  
  /// Fetches the sprite image `URL` for a given Pokémon name.
  /// - Parameter name: The name of the Pokémon to look up.
  /// - Returns: An `AnyPublisher<URL, TruePokemonSDKError>` that emits the sprite `URL`
  ///            or fails with `TruePokemonSDKError`.
  public func getPokemonSpriteURL(from name: String) -> AnyPublisher<URL, TruePokemonSDKError> {
    Networking.Service.Pokemon(networkService: NetworkService())
      .detail(from: name)
      .mapError { _ in TruePokemonSDKError.networkError }
      .flatMap { pokemon in
        guard let url = pokemon.imageUrl else {
          return Fail<URL, TruePokemonSDKError>(error: TruePokemonSDKError.responseError)
            .eraseToAnyPublisher()
        }
        
        return Just(url)
          .setFailureType(to: TruePokemonSDKError.self)
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  /// Asynchronously fetches the sprite image `URL` for a given Pokémon name.
  /// - Parameter name: The name of the Pokémon to look up.
  /// - Throws: `TruePokemonSDKError` if the request fails.
  /// - Returns: The sprite `URL` of the specified Pokémon.
  public func getPokemonSpriteURL(from name: String) async throws -> URL {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
      var cancellable: AnyCancellable?
      cancellable = getPokemonSpriteURL(from: name)
        .sink(
          receiveCompletion: { completion in
            switch completion {
            case .finished:
              break
            case .failure(let error):
              continuation.resume(throwing: error)
            }
            cancellable?.cancel()
          },
          receiveValue: { url in
            continuation.resume(returning: url)
            cancellable?.cancel()
          }
        )
    }
  }
  
  /// Fetches a Shakespearean-style translation of a Pokémon’s description.
  /// - Parameter name: The name of the Pokémon that description will be translated.
  /// - Returns: An `AnyPublisher<String, TruePokemonSDKError>` that emits the translated text
  ///            or fails with `TruePokemonSDKError`.
  public func getShakespeareTranslation(from name: String) -> AnyPublisher<String, TruePokemonSDKError> {
    Networking.Service.Pokemon(networkService: NetworkService())
      .detail(from: name)
      .mapError { _ in TruePokemonSDKError.networkError }
      .flatMap { pokemon in
        guard let description = pokemon.description else {
          return Fail<String, TruePokemonSDKError>(error: TruePokemonSDKError.responseError)
            .eraseToAnyPublisher()
        }
        
        return Networking.Service.Shakespeare(networkService: NetworkService())
          .description(from: pokemon.description ?? "")
          .mapError { _ in TruePokemonSDKError.networkError }
          .map { description in
            return description.text
          }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  /// Asynchronously fetches a Shakespearean-style translation of a Pokémon’s description.
  /// - Parameter name: The name of the Pokémon that description will be translated.
  /// - Throws: `TruePokemonSDKError` if the request fails.
  /// - Returns: The translated description as a `String`.
  public func getShakespeareTranslation(from name: String) async throws -> String {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
      var cancellable: AnyCancellable?
      cancellable = getShakespeareTranslation(from: name)
        .sink(
          receiveCompletion: { completion in
            switch completion {
            case .finished:
              break
            case .failure(let error):
              continuation.resume(throwing: error)
            }
            cancellable?.cancel()
          },
          receiveValue: { description in
            continuation.resume(returning: description)
            cancellable?.cancel()
          }
        )
    }
  }
}
