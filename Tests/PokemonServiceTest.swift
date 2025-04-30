//  TruePokemonSDK
//
//  Created by Enzo on 30/04/25.
//

import Foundation
import Combine
import XCTest
@testable import TruePokemonSDK

final class PokemonServiceTest: XCTestCase {
  var mockNetworkService: MockNetworkService!
  var pokemonService: Networking.Service.Pokemon!
  private var cancellables = Set<AnyCancellable>()
  
  override func setUp() {
    super.setUp()
    mockNetworkService = MockNetworkService()
    pokemonService = Networking.Service.Pokemon(networkService: mockNetworkService)
    
    mockNetworkService.mockResponses = [
      "v2/pokemon/bulbasaur": "GetPokemonDetail",
      "v2/pokemon-species/1": "GetPokemonSpecies"
    ]
  }
  
  override func tearDown() {
    cancellables.removeAll()
    pokemonService = nil
    mockNetworkService = nil
    super.tearDown()
  }
  
  func test_fetchPokemons_success() throws {
    let expectation = XCTestExpectation(description: "Fetch Pokémon detail")
    var resultPokemon: Model.App.Pokemon?
    var resultError: Error?
    
    pokemonService.detail(from: "bulbasaur")
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case .failure(let error):
          resultError = error
          expectation.fulfill()
        }
      }, receiveValue: { pokemonDetail in
        resultPokemon = pokemonDetail
      })
      .store(in: &cancellables)
    
    wait(for: [expectation], timeout: 1.0)
    
    XCTAssertNil(resultError)
    XCTAssertEqual(resultPokemon?.id, 1)
    XCTAssertEqual(resultPokemon?.name, "bulbasaur")
    XCTAssertEqual(resultPokemon?.description, "A strange seed was\nplanted on its\nback at birth.\u{0C}The plant sprouts\nand grows with\nthis POKéMON.")
  }
}
