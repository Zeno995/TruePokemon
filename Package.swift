// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TruePokemon",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "TruePokemonSDK",
      targets: ["TruePokemonSDK"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/kean/Nuke.git", from: "10.0.0"),
  ],
  targets: [
    .target(
      name: "TruePokemonSDK",
      dependencies: ["Nuke"],
      path: "Sources"
    ),
    .testTarget(
      name: "TruePokemonSDKTests",
      dependencies: ["TruePokemonSDK"],
      path: "Tests"
    ),
  ]
)
