//
//  ShakespeareViewModel.swift
//  TruePokemon
//
//  Created by Enzo on 04/05/25.
//

import Combine
import Foundation

class ShakespeareViewModel: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  
  @Published var state: State
  
  init(name: String) {
    self.state = .loading
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
            self?.state = .error(error)
          }
        },
        receiveValue: { [weak self] pokemon in
          guard let description = pokemon.description else {
            self?.state = .error(ServiceError.unknown)
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
            self?.state = .error(error)
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
    case error(ServiceError)
    
    static func == (lhs: ShakespeareViewModel.State, rhs: ShakespeareViewModel.State) -> Bool {
      switch (lhs, rhs) {
      case let (.loading, .loading):
        return true
        
      case let (.loaded(lhs), .loaded(rhs)):
        return lhs == rhs
        
      case let (.error(lhs), .error(rhs)):
        return lhs.localizedDescription == rhs.localizedDescription
        
      default:
        return false
      }
    }
  }
}

extension ShakespeareViewModel: Equatable {
  static func == (lhs: ShakespeareViewModel, rhs: ShakespeareViewModel) -> Bool {
    lhs.state == rhs.state
  }
}
