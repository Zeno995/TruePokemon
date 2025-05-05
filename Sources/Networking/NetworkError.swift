//
//  NetworkError.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

/// The errors about network requestes.
public enum NetworkError: Error {
  case invalidRequest
  case requestFailed(statusCode: Int)
  case decodingFailed(Error)
  case unknown(Error)
  
  var localizedDescription: String {
    switch self {
    case .invalidRequest:
      return "Request not valid"
      
    case let .requestFailed(statusCode):
      return "Request failed with status code: \(statusCode)"
      
    case let .decodingFailed(error):
      return "Deconding failed with error: \(error.localizedDescription)"
      
    case let .unknown(error):
      return "Generic error: \(error.localizedDescription)"
    }
  }
}
