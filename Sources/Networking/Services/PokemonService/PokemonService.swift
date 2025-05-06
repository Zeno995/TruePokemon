//
//  PokemonService.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Combine
import Foundation

extension Networking.Service {
  struct Pokemon: PokemonProtocol {
    private let networkService: NetworkProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkProtocol = NetworkService()) {
      self.networkService = networkService
    }
    
    func detail(from name: String) -> AnyPublisher<Model.App.Pokemon, ServiceError> {
      let request = Request.Detail(name: name)
      return networkService.perform(request)
        .mapError { ServiceError.network($0) }
        .flatMap { detailResponse in
          let request = Request.Species(id: detailResponse.id)
          return networkService.perform(request)
            .mapError { ServiceError.network($0) }
            .map { speciesResponse in
              return Model.Response.Pokemon(detail: detailResponse, species: speciesResponse).normalizedForApp()
            }
            .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    func clearCache() {
      networkService.clearCache()
    }
  }
}
