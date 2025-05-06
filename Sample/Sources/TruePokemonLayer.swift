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
  
  func verifyPokemon(from name: String) async throws -> Bool {
    try await client.verifyPokemon(from: name)
  }
}
