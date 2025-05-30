//
//  NetworkManager.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Combine
import Foundation

/// A service responsible for executing HTTP requests and decoding JSON responses.
///
/// Usage example:
/// ```swift
/// let service = NetworkService()
/// let publisher: AnyPublisher<MyResponseModel, NetworkError> =
///     service.perform(MyAPIRequest(...))
///
/// publisher
///   .sink(
///     receiveCompletion: { completion in
///       switch completion {
///       case .finished:
///         break
///       case .failure(let error):
///         print("Network error:", error)
///       }
///     },
///     receiveValue: { model in
///       print("Decoded response:", model)
///     }
///   )
/// ```
struct NetworkService: NetworkProtocol {
  private let session: URLSession
  private let cache: NetworkCache
  
  init(session: URLSession = .shared, cache: NetworkCache = NetworkCache()) {
    self.session = session
    self.cache = cache
  }
  
  /// Clean all caches.
  func clearCache() {
    cache.clearCache()
  }
  
  /// Performs a network request defined by an `APIRequest` and decodes the JSON response.
  /// - Parameter request: An object conforming to `APIRequest`.
  /// - Returns: An `AnyPublisher` that emits:
  ///   - `T.Response` on success, where `T.Response` is a `Decodable` type.
  ///   - `NetworkError` on failure.
  func perform<T: APIRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkError> {
    guard var urlComponents = URLComponents(string: request.baseURL + request.path) else {
      return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
    }
    
    guard let url = urlComponents.url else {
      return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    switch request.method {
    case .get, .delete:
      urlComponents.queryItems = request.queryItems
      
    case .post, .put:
      if let bodyData = request.body {
        urlRequest.httpBody = bodyData
      } else if let queryItems = request.queryItems {
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = queryItems
        urlRequest.httpBody = bodyComponents
          .percentEncodedQuery?
          .data(using: .utf8)
      }
    }
    
    for (key, value) in request.headers {
      urlRequest.addValue(value, forHTTPHeaderField: key)
    }
    
    if request.useCache {
      if let cachedData = cache.retrieveFromCache(for: url, bodyData: urlRequest.httpBody) {
        do {
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .iso8601
          let decodedResponse = try decoder.decode(T.Response.self, from: cachedData)
          
          return Just(decodedResponse)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
        } catch {
          print("Cache coding error: \(error.localizedDescription)")
        }
      }
    }
    
    return session.dataTaskPublisher(for: urlRequest)
      .mapError { NetworkError.unknown($0) }
      .flatMap { data, response -> AnyPublisher<T.Response, NetworkError> in
        guard let httpResponse = response as? HTTPURLResponse else {
          return Fail(error: NetworkError.unknown(NSError())).eraseToAnyPublisher()
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
          return Fail(error: NetworkError.requestFailed(statusCode: httpResponse.statusCode)).eraseToAnyPublisher()
        }
        
        if request.useCache {
          cache.saveToCache(data: data, for: url, bodyData: urlRequest.httpBody, expirationInterval: request.cacheExpirationInterval)
        }
        
        do {
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .iso8601
          let decodedResponse = try decoder.decode(T.Response.self, from: data)
          return Just(decodedResponse)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
        } catch {
          return Fail(error: NetworkError.decodingFailed(error)).eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }
}
