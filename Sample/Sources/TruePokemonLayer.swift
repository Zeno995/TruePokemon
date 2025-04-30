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
    client.getPokemon()
      .receive(on: DispatchQueue.main)
      .sink { error in
      print(error)
    } receiveValue: { pokemon in
      print(pokemon)
    }
    .store(in: &cancellables)
  }
}
