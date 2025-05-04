//
//  ShakespeareViewModel.swift
//  TruePokemon
//
//  Created by Enzo on 04/05/25.
//

import Combine
import Foundation

class ShakespeareViewModel: ObservableObject {
  private var name: String?
  private var cancellables = Set<AnyCancellable>()
  
  @Published var state: State
  var isColored: Bool
  var isAnimated: Bool
  
  init(name: String, isAnimated: Bool, isColored: Bool) {
    self.state = .loading
    self.isAnimated = isAnimated
    self.isColored = isColored
    loadDescriptionFrom(name: name)
  }
  
  deinit {
    cancellables.removeAll()
  }
  
  private func loadDescriptionFrom(name: String) {
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
          guard let description = pokemon.description else {
            self?.state = .error
            return
          }
          
          self?.loadShakespeareDescription(description)
        }
      )
      .store(in: &cancellables)
    
  }
  
  private func loadShakespeareDescription(_ description: String) {
    Networking.Service.Shakespeare(networkService: NetworkService())
      .description(from: description)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          if case .failure(let error) = completion {
            self?.state = .error
          }
        },
        receiveValue: { [weak self] response in
          self?.state = .loaded(response.text)
        }
      )
      .store(in: &cancellables)
  }
}

extension ShakespeareViewModel {
  enum State: Equatable {
    case loading
    case loaded(String)
    case error
  }
}

extension ShakespeareViewModel: Equatable {
  static func == (lhs: ShakespeareViewModel, rhs: ShakespeareViewModel) -> Bool {
    lhs.state == rhs.state
  }
}
