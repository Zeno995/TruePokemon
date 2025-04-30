//
//  TruePokemonSDKError.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

/// The TruePokemonSDK errors.
public enum TruePokemonSDKError: Error {
  case unknown
  
  var localizedDescription: String {
    switch self {      
    case .unknown:
      return "Si è verificato un errore sconosciuto."
    }
  }
}

