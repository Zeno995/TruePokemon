import Foundation

private class BundleFinder {}

extension Bundle {
  /// The sdk bundle.
  static let sdk: Bundle = {
    let bundleName = "TruePokemon_TruePokemonSDK"
    
    let candidates = [
      Bundle.main.resourceURL,
      Bundle(for: BundleFinder.self).resourceURL,
      Bundle.main.bundleURL
    ]
    
    for candidate in candidates {
      if let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle"),
         let bundle = Bundle(url: bundlePath) {
        return bundle
      }
    }
    
    fatalError("Cannot find TruePokemon_TruePokemonSDK")
  }()
}
