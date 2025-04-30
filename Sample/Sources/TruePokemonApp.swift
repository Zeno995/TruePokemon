//
//  HTTPMethod.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import TruePokemonSDK
import SwiftUI

@main
struct TruePokemonApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(TruePokemonLayer(client: TruePokemonSDK()))
    }
  }
}
