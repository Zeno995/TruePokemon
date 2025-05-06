//
//  NetworkCache.swift
//  TruePokemon
//
//  Created by Enzo on 06/05/25.
//

import CommonCrypto
import CryptoKit
import Foundation

/// SDK cache managment.
struct NetworkCache {
  private struct Item: Codable {
    let data: Data
    let expirationDate: Date
    
    var isExpired: Bool {
      return Date.now > expirationDate
    }
  }
  
  private let fileManager: FileManager
  private let cacheDirectory: URL
  
  init() {
    self.fileManager = .default
    
    let baseURL: URL
    if let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
      baseURL = url
    } else if let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
      baseURL = url
    } else {
      baseURL =  fileManager.temporaryDirectory
    }
    
    self.cacheDirectory = baseURL.appendingPathComponent("NetworkCache", isDirectory: true)
    do {
      try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    } catch {
      print("Error during cache creation: \(error.localizedDescription)")
    }
  }
  
  /// Save `Data` in cache.
  /// - Parameters:
  ///   - data: `Data` to save.
  ///   - url: The request `URL`.
  ///   - bodyData: The body `Data`, if present.
  ///   - expirationInterval: The cache expiration `TimeInterval`.
  func saveToCache(data: Data, for url: URL, bodyData: Data? = nil, expirationInterval: TimeInterval) {
    let expirationDate = Date().addingTimeInterval(expirationInterval)
    let cacheEntry = Item(data: data, expirationDate: expirationDate)
    
    do {
      let encoder = JSONEncoder()
      let encodedData = try encoder.encode(cacheEntry)
      let fileURL = cacheDirectory.appendingPathComponent(cacheKey(for: url, bodyData: bodyData))
      try encodedData.write(to: fileURL)
    } catch {
      print("Error during cache saving: \(error.localizedDescription)")
    }
  }
  
  /// Retrieves `Data` from the cache.
  /// - Parameters:
  ///   - url: The request `URL`.
  ///   - bodyData: The body `Data`, if present.
  /// - Returns: The cache `Data` or nil, if dont't exist datas or if they are expired.
  func retrieveFromCache(for url: URL, bodyData: Data? = nil) -> Data? {
    let fileURL = cacheDirectory.appendingPathComponent(cacheKey(for: url, bodyData: bodyData))
    guard fileManager.fileExists(atPath: fileURL.path) else {
      return nil
    }
    
    do {
      let data = try Data(contentsOf: fileURL)
      let decoder = JSONDecoder()
      let cacheEntry = try decoder.decode(Item.self, from: data)
      
      if cacheEntry.isExpired {
        removeFromCache(for: url, bodyData: bodyData)
        return nil
      }
      
      return cacheEntry.data
    } catch {
      print("Retrieve cache error: \(error.localizedDescription)")
      return nil
    }
  }
  
  /// Remove an element from cache.
  /// - Parameters:
  ///   - url: The request `URL`.
  ///   - bodyData: The body `Data`, if present.
  func removeFromCache(for url: URL, bodyData: Data? = nil) {
    let fileURL = cacheDirectory.appendingPathComponent(cacheKey(for: url, bodyData: bodyData))
    
    do {
      if fileManager.fileExists(atPath: fileURL.path) {
        try fileManager.removeItem(at: fileURL)
      }
    } catch {
      print("Removing cache error: \(error.localizedDescription)")
    }
  }
  
  /// Clean all cache.
  func clearCache() {
    do {
      let cachedFiles = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
      
      for fileURL in cachedFiles {
        try fileManager.removeItem(at: fileURL)
      }
    } catch {
      print("Cleaning cache error: \(error.localizedDescription)")
    }
  }
  
  /// Generates a cache key.
  /// - Parameters:
  ///   - url: The request `URL`.
  ///   - bodyData: The `Data` of the request body.
  /// - Returns: The cache key.
  private func cacheKey(for url: URL, bodyData: Data? = nil) -> String {
    var components = [url.absoluteString]
    if let bodyData = bodyData {
      let bodyString = bodyData.base64EncodedString()
      components.append(bodyString)
    }
    
    let combinedString = components.joined(separator: "_")
    let inputData = Data(combinedString.utf8)
    let hashed = SHA256.hash(data: inputData)
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
  }
}
