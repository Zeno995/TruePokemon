//
//  SpriteViewModel.swift
//  TruePokemon
//
//  Created by Enzo on 04/05/25.
//

import Foundation
import Combine

class SpriteViewModel: ObservableObject {
  @Published var state: State
  
  private var name: String?
  private var cancellables = Set<AnyCancellable>()
  
  init(name: String) {
    self.state = .loading
    loadSpriteURLFrom(name: name)
  }
  
  init(url: URL) {
    self.state = .loaded(url)
  }
  
  deinit {
    cancellables.removeAll()
  }
  
  func loadSpriteURLFrom(name: String) {
    Networking.Service.Pokemon(networkService: NetworkService())
      .detail(from: name)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          if case .failure(let error) = completion {
            self?.state = .error
          }
        },
        receiveValue: { [weak self] pokemon in
          guard let url = pokemon.imageUrl else {
            self?.state = .error
            return
          }
          
          self?.state = .loaded(url)
        }
      )
      .store(in: &cancellables)
  }
}

extension SpriteViewModel {
  enum State {
    case loaded(URL)
    case loading
    case error
  }
}
