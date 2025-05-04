//
//  ShakespeareApiRequest.swift
//  TruePokemonSDK
//
//  Created by Enzo on 30/04/25.
//

import Foundation

protocol ShakespeareApiRequest: APIRequest {}

extension ShakespeareApiRequest {
  var baseURL: String { "https://api.funtranslations.com" }
}
