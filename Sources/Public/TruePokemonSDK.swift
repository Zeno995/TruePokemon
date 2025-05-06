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
  
  /// Verifies if the Pokémon exist for a given name.
  /// - Parameter name: The name of the Pokémon to verify.
  /// - Returns: An `AnyPublisher<Bool, TruePokemonSDKError>` that emits the `Bool` value
  ///            or fails with `TruePokemonSDKError`.
  ///
  /// Usage example:
  /// ```swift
  /// client.verifyPokemon(from: "Bulbasaur")
  ///  .sink { completion in
  ///    switch completion {
  ///    case .finished:
  ///      break
  ///    case .failure(let error):
  ///      print("Network error:", error)
  ///    }
  ///  } receiveValue: { isVerified in
  ///    print("Decoded response:", isVerified)
  ///  }
  /// ```
  public func verifyPokemon(from name: String) -> AnyPublisher<Bool, TruePokemonSDKError> {
    Networking.Service.Pokemon(networkService: NetworkService())
      .detail(from: name)
      .mapError { error in
        if case .network(let networkError) = error, case .requestFailed(let statusCode) = networkError, statusCode == 404 {
          TruePokemonSDKError.pokemonNotFound
        } else {
          TruePokemonSDKError.serviceError(error)
        }
      }
      .flatMap { _ in
        return Just(true)
          .setFailureType(to: TruePokemonSDKError.self)
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  /// Verifies if the Pokémon exist for a given name.
  /// - Parameter name: The name of the Pokémon to verify.
  /// - Returns: An `AnyPublisher<Bool, TruePokemonSDKError>` that emits the `Bool` value
  ///            or fails with `TruePokemonSDKError`.
  ///
  /// Usage example:
  /// ```swift
  /// let isVerified = try await client.verifyPokemon(from: name)
  /// ```
  public func verifyPokemon(from name: String) async throws -> Bool {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
      var cancellable: AnyCancellable?
      cancellable = verifyPokemon(from: name)
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
          receiveValue: { isVerified in
            continuation.resume(returning: isVerified)
            cancellable?.cancel()
          }
        )
    }
  }
  
  /// Fetches the sprite image `URL` for a given Pokémon name.
  /// - Parameter name: The name of the Pokémon to look up.
  /// - Returns: An `AnyPublisher<URL, TruePokemonSDKError>` that emits the sprite `URL`
  ///            or fails with `TruePokemonSDKError`.
  ///
  /// Usage example:
  /// ```swift
  /// client.getPokemonSpriteURL(from: "Bulbasaur")
  ///  .sink { completion in
  ///    switch completion {
  ///    case .finished:
  ///      break
  ///    case .failure(let error):
  ///      print("Network error:", error)
  ///    }
  ///  } receiveValue: { imageURL in
  ///    print("Decoded response:", imageURL)
  ///  }
  /// ```
  public func getPokemonSpriteURL(from name: String) -> AnyPublisher<URL, TruePokemonSDKError> {
    Networking.Service.Pokemon(networkService: NetworkService())
      .detail(from: name)
      .mapError { TruePokemonSDKError.serviceError($0) }
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
  ///
  /// Usage example:
  /// ```swift
  /// let spriteURL = try await client.getPokemonSpriteURL(from: name)
  /// ```
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
  ///
  /// Usage example:
  /// ```swift
  /// client.getShakespeareTranslation(from: "Bulbasaur")
  ///  .sink { completion in
  ///    switch completion {
  ///    case .finished:
  ///      break
  ///    case .failure(let error):
  ///      print("Network error:", error)
  ///    }
  ///  } receiveValue: { translation in
  ///    print("Decoded response:", translation)
  ///  }
  /// ```
  public func getShakespeareTranslation(from name: String) -> AnyPublisher<String, TruePokemonSDKError> {
    Networking.Service.Pokemon(networkService: NetworkService())
      .detail(from: name)
      .mapError { TruePokemonSDKError.serviceError($0) }
      .flatMap { pokemon in
        guard let description = pokemon.description else {
          return Fail<String, TruePokemonSDKError>(error: TruePokemonSDKError.responseError)
            .eraseToAnyPublisher()
        }
        
        return Networking.Service.Shakespeare(networkService: NetworkService())
          .description(from: pokemon.description ?? "")
          .mapError { TruePokemonSDKError.serviceError($0) }
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
  ///
  /// Usage example:
  /// ```swift
  /// let shakespeareTranslation = try await client.getShakespeareTranslation(from: name)
  /// ```
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
