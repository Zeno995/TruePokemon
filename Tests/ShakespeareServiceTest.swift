//
//  ShakespeareServiceTest.swift
//  TruePokemonSampleApp
//
//  Created by Enzo on 30/04/25.
//  Copyright © 2025 EC. All rights reserved.
//

import Combine
import Foundation
import Nimble
import XCTest
@testable import TruePokemonSDK

final class ShakespeareServiceTest: XCTestCase {
  var mockNetworkService: MockNetworkService!
  var shakespeareService: Networking.Service.Shakespeare!
  private var cancellables = Set<AnyCancellable>()
  
  override func setUp() {
    super.setUp()
    mockNetworkService = MockNetworkService()
    shakespeareService = Networking.Service.Shakespeare(networkService: mockNetworkService)
    
    mockNetworkService.mockResponses = [
      "translate/shakespeare.json": "PostShakespeareTranslate"
    ]
  }
  
  override func tearDown() {
    cancellables.removeAll()
    shakespeareService = nil
    mockNetworkService = nil
    super.tearDown()
  }
  
  func test_fetchTralnsate_success() throws {
    let expectation = XCTestExpectation(description: "Fetch shakespeare description")
    var resultShakespeare: Model.App.Shakespeare.Translate?
    var resultError: Error?
    
    shakespeareService.description(from: "text")
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case .failure(let error):
          resultError = error
          expectation.fulfill()
        }
      }, receiveValue: { shakespeare in
        resultShakespeare = shakespeare
      })
      .store(in: &cancellables)
    
    wait(for: [expectation], timeout: 1.0)
    expect(resultError).to(beNil())
    expect(resultShakespeare).toNot(beNil())
    expect(resultShakespeare?.text).to(equal("Capable of copying an foe's genetic code to instantly transform itself into a duplicate of the foe."))
  }
}
