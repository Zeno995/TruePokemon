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
    .package(url: "https://github.com/kean/Nuke.git", from: "12.8.0"),
  ],
  targets: [
    .target(
      name: "TruePokemonSDK",
      dependencies: [
        "Nuke",
        .product(name: "NukeUI", package: "Nuke")
      ],
      path: "Sources",
      resources: [
        .process("Resources")
      ]
    ),
    .testTarget(
      name: "TruePokemonSDKTests",
      dependencies: ["TruePokemonSDK"],
      path: "Tests"
    ),
  ]
)
