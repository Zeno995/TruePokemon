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
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
