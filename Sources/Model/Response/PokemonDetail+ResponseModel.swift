//
//  PokemonDetail+ResponseModel.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

extension Model.Response.Pokemon {
  /// The Pokémon detail response object.
  struct Detail: Decodable {
    let id: Int
    let name: String
    let types: [Kind]
    let sprites: Sprite
    let species: Species
  }
}

extension Model.Response.Pokemon.Detail {
  /// The Pokémon Type detail response object, with the string url to get more data.
  struct Kind: Decodable {
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
      case type
    }
    
    enum TypeKeys: String, CodingKey {
      case url
      case name
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let typeContainer = try container.nestedContainer(keyedBy: TypeKeys.self, forKey: .type)
      url = try typeContainer.decode(String.self, forKey: .url)
      name = try typeContainer.decode(String.self, forKey: .name)
    }
  }
  
  /// The Pokémon official sprite.
  struct Sprite: Decodable {
    let frontDefault: String
    
    enum SpritesKeys: String, CodingKey {
      case other
    }
    
    enum OtherKeys: String, CodingKey {
      case officialArtwork = "official-artwork"
    }
    
    enum OfficialKeys: String, CodingKey {
      case frontDefault = "front_default"
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: SpritesKeys.self)
      let artworkContainer = try container.nestedContainer(keyedBy: OtherKeys.self, forKey: .other)
      let finalContainer = try artworkContainer.nestedContainer(keyedBy: OfficialKeys.self, forKey: .officialArtwork)
      frontDefault = try finalContainer.decode(String.self, forKey: .frontDefault)
    }
  }
  
  /// The Pokémon species info, containing the url to get the description.
  struct Species: Decodable {
    let url: String
  }
}
