//
//  TruePokemonErrors.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

enum ServiceError: Error {
  case network(NetworkError)
  case unknown
  
  var localizedDescription: String {
    switch self {
    case .network(let error):
      return "Errore di rete: \(error.localizedDescription)"
      
    case .unknown:
      return "Si è verificato un errore sconosciuto."
    }
  }
}
