//
//  NetworkCacheTest.swift
//  TruePokemonSDK
//
//  Created by Enzo on 06/05/25.
//

import Combine
import Foundation
import Nimble
import XCTest
@testable import TruePokemonSDK

class NetworkCacheTest: XCTestCase {
  var networkCache: NetworkCache!
  var testUrl: URL!
  var testData: Data!
  var expirationInterval: TimeInterval!
  
  override func setUp() {
    super.setUp()
    networkCache = NetworkCache()
    testUrl = URL(string: "https://pokeapi.co/api/v2/pokemon/ditto")!
    testData = "Test data".data(using: .utf8)!
    expirationInterval = 60
    networkCache.clearCache()
  }
  
  override func tearDown() {
    networkCache.clearCache()
    networkCache = nil
    testUrl = nil
    testData = nil
    expirationInterval = nil
    super.tearDown()
  }
  
  func test_saveAndRetrieveFromCache_success() {
    networkCache.saveToCache(data: testData, for: testUrl, expirationInterval: expirationInterval)
    
    let retrievedData = networkCache.retrieveFromCache(for: testUrl)
    expect(retrievedData).toNot(beNil())
    expect(retrievedData).to(equal(testData))
  }
  
  func test_saveAndRetrieveWithBodyData_success() {
    let bodyData = "String body".data(using: .utf8)!
    networkCache.saveToCache(data: testData, for: testUrl, bodyData: bodyData, expirationInterval: expirationInterval)
    
    let retrievedData = networkCache.retrieveFromCache(for: testUrl, bodyData: bodyData)
    expect(retrievedData).toNot(beNil())
    expect(retrievedData).to(equal(testData))
  }
  
  func test_differentBodyData_shouldReturnNil() {
    let savedBodyData = "String body to save".data(using: .utf8)!
    let retriveBodyData = "String body to retrive".data(using: .utf8)!
    
    networkCache.saveToCache(data: testData, for: testUrl, bodyData: savedBodyData, expirationInterval: expirationInterval)
    let retrievedData = networkCache.retrieveFromCache(for: testUrl, bodyData: retriveBodyData)
    expect(retrievedData).to(beNil())
  }
  
  func test_expiredCache_shouldReturnNil() {
    networkCache.saveToCache(data: testData, for: testUrl, expirationInterval: 0.1) // 100 ms
    Thread.sleep(forTimeInterval: 0.2)
    let retrievedData = networkCache.retrieveFromCache(for: testUrl)
    expect(retrievedData).to(beNil())
  }
  
  func test_removeFromCache_success() {
    networkCache.saveToCache(data: testData, for: testUrl, expirationInterval: expirationInterval)
    expect(self.networkCache.retrieveFromCache(for: self.testUrl)).toNot(beNil())
    networkCache.removeFromCache(for: testUrl)
    expect(self.networkCache.retrieveFromCache(for: self.testUrl)).to(beNil())
  }
  
  func test_clearCache_success() {
    let url1 = URL(string: "https://pokeapi.co/api/v2/pokemon/ditto")!
    let url2 = URL(string: "https://pokeapi.co/api/v2/pokemon/pikachu")!
    let data1 = "Test data 1".data(using: .utf8)!
    let data2 = "Test data 2".data(using: .utf8)!
    networkCache.saveToCache(data: data1, for: url1, expirationInterval: expirationInterval)
    networkCache.saveToCache(data: data2, for: url2, expirationInterval: expirationInterval)
    
    expect(self.networkCache.retrieveFromCache(for: url1)).toNot(beNil())
    expect(self.networkCache.retrieveFromCache(for: url2)).toNot(beNil())
    
    networkCache.clearCache()
    
    expect(self.networkCache.retrieveFromCache(for: url1)).to(beNil())
    expect(self.networkCache.retrieveFromCache(for: url2)).to(beNil())
  }
} 
