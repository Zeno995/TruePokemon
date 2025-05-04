//
//  TruePokemonSDKError.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

/// The TruePokemonSDK errors.
public enum TruePokemonSDKError: Error {
  case networkError
  
  case responseError
  
  case unknown
  
  var localizedDescription: String {
    switch self {
    case .networkError:
      return "Network error, retry"
      
    case .responseError:
      return "The response is incomplete, retry"
      
    case .unknown:
      return "Generic error"
    }
  }
}

