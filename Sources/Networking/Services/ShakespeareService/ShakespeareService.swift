//
//  ShakespeareService.swift
//  TruePokemonSDK
//
//  Created by Enzo on 30/04/25.
//

import Combine
import Foundation

extension Networking.Service {
  struct Shakespeare: ShakespeareProtocol {
    
    private let networkService: NetworkProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkProtocol = NetworkService()) {
      self.networkService = networkService
    }
    
    func description(from text: String) -> AnyPublisher<Model.App.Shakespeare.Translate, ServiceError> {
      let request = Request.Translate(text: text)
      return networkService.perform(request)
        .mapError { ServiceError.network($0) }
        .map { response in
          response.normalizedForApp()
        }
        .eraseToAnyPublisher()
    }
  }
}
