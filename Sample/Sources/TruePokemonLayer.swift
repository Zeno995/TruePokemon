//
//  ViewModel.swift
//  TruePokemonSampleApp
//
//  Created by Enzo on 29/04/25.
//  Copyright © 2025 EC. All rights reserved.
//

import Foundation
import Combine
import TruePokemonSDK

class TruePokemonLayer: ObservableObject {
  private let client: TruePokemonSDK
  private var cancellables = Set<AnyCancellable>()
  
  init(client: TruePokemonSDK) {
    self.client = client
  }
  
  func getDitto() {
    client.getPokemonSpriteURL(from: "Ditto")
      .receive(on: DispatchQueue.main)
      .sink { error in
      print(error)
    } receiveValue: { pokemon in
      print(pokemon)
    }
    .store(in: &cancellables)
    
    Task {
      let spriteUrl = try? await client.getPokemonSpriteURL(from: "ditto")
      print("With async await: \(String(describing: spriteUrl))")
    }
  }
  
  func getShackespeareDitto() {
    client.getShakespeareTranslation(from: "ditto")
      .receive(on: DispatchQueue.main)
      .sink { error in
      print(error)
    } receiveValue: { translation in
      print(translation)
    }
    .store(in: &cancellables)
    
    Task {
      let description = try? await client.getShakespeareTranslation(from: "ditto")
      print("With async await: \(String(describing: description))")
    }
  }
}
