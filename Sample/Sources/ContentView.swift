import SwiftUI
import TruePokemonSDK

public struct ContentView: View {
  private let sdk = TruePokemonSDK()
  
  public init() {}
  
  public var body: some View {
    VStack {
      Text("Sampe app")
        .padding()
      
      Button("Test SDK") {
        sdk.printSomething()
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
