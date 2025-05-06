//
//  PokemonSpecies+ResponseModel.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Foundation

extension Model.Response.Pokemon {
  /// The Pokémon spacies.
  struct Species: Decodable {
    let flavorTextEntries: [Flavor]
    
    enum CodingKeys: String, CodingKey {
      case flavorTextEntries = "flavor_text_entries"
    }
  }
}

extension Model.Response.Pokemon.Species {
  /// The species flavor, containing the text and the language code.
  struct Flavor: Decodable {
    let text: String
    let languageName: String
    
    enum CodingKeys: String, CodingKey {
      case text = "flavor_text"
      case language
    }
    
    enum LanguageKeys: String, CodingKey {
      case name
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let languageContainer = try container.nestedContainer(keyedBy: LanguageKeys.self, forKey: .language)
      languageName = try languageContainer.decode(String.self, forKey: .name)
      text = try container.decode(String.self, forKey: .text)
    }
    
    init(text: String, languageName: String) {
      self.text = text
      self.languageName = languageName
    }
  }
}
