//
//  HTTPMethod.swift
//  TruePokemonSDK
//
//  Created by Enzo on 29/04/25.
//

import Combine
import SwiftUI
import TruePokemonSDK

public struct ContentView: View {
  @EnvironmentObject var layer: TruePokemonLayer
  
  public init() {}
  
  public var body: some View {
    VStack {
      Text("Sampe app")
        .padding()
      
      Button("Test SDK") {
        layer.getDitto()
      }
      .padding()
      
      Button("Test shakespeare") {
        layer.getShackespeareDitto()
      }
      .padding()
      
      SpriteView(name: "venusaur")
        .frame(width: 100, height: 100)
        .padding()
      
      ShakespeareView(name: "venusaur", isAnimated: true, isColored: true)
        .padding()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
