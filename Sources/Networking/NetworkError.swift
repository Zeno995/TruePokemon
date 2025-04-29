//
//  NetworkError.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

enum NetworkError: Error {
  case invalidRequest
  case requestFailed(statusCode: Int)
  case decodingFailed(Error)
  case unknown(Error)
}
