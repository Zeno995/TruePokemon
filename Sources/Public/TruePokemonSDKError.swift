//
//  TruePokemonSDKError.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

/// The TruePokemonSDK errors.
public enum TruePokemonSDKError: Error {
  case serviceError(ServiceError)
  
  case responseError
  
  case unknown
  
  var localizedDescription: String {
    switch self {
    case let .serviceError(error):
      return error.localizedDescription
      
    case .responseError:
      return "The response is incomplete, retry"
      
    case .unknown:
      return "Generic error"
    }
  }
}

