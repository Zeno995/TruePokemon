// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TruePokemonSampleApp",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .executable(
      name: "TruePokemonSampleApp",
      targets: ["TruePokemonSampleApp"]
    ),
  ],
  dependencies: [
    .package(name: "TruePokemon", path: "..")
  ],
  targets: [
    .executableTarget(
      name: "TruePokemonSampleApp",
      dependencies: [
        .product(name: "TruePokemonSDK", package: "TruePokemon")
      ],
      path: "Sources",
      resources: [
        .process("Resources")
      ]
    )
  ]
) 
