//
//  TruePokemonErrors.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

/// The service errors.
public enum ServiceError: Error {
  case network(NetworkError)
  case unknown
  
  var localizedDescription: String {
    switch self {
    case .network(let error):
      return error.localizedDescription
      
    case .unknown:
      return "Generic error"
    }
  }
}
