//
//  ShakespeareTranslate+ResponseModel.swift
//  TruePokemonSDK
//
//  Created by Enzo on 30/04/25.
//

extension Model.Response.Shakespeare {
  /// The Shakespeare translate object.
  struct Translate: Decodable {
    let text: String
    
    enum TranslateKeys: String, CodingKey {
      case contents
    }
    
    enum ContentKeys: String, CodingKey {
      case translated
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: TranslateKeys.self)
      let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .contents)
      text = try contentContainer.decode(String.self, forKey: .translated)
    }
    
    init(text: String) {
      self.text = text
    }
  }
}

// MARK: - Normalization

extension Model.Response.Shakespeare.Translate: Normalizable {
  func normalizedForApp() -> Model.App.Shakespeare.Translate {
    Model.App.Shakespeare.Translate(text: text)
  }
}
