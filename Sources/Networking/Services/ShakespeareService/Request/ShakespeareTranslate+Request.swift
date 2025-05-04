//
//  Untitled.swift
//  TruePokemonSDK
//
//  Created by Enzo on 30/04/25.
//

import Foundation

extension Networking.Service.Shakespeare.Request {
  /// The request to translate text in shakespeare version.
  struct Translate: ShakespeareApiRequest {
    typealias Response = Model.Response.Shakespeare.Translate
    let text: String
    var path: String { "/translate/shakespeare.json" }
    var method: HTTPMethod { .post }
    var headers: [String: String] {
      ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    }
    var queryItems: [URLQueryItem]? { [URLQueryItem(name: "text", value: text)] }
  }
}
