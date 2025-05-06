# TruePokemonSDK

![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![Swift](https://img.shields.io/badge/swift-5.5-orange.svg)

A Swift SDK that allows you to fetch and display Pokémon information with Shakespearean-style descriptions. Designed to be easily integrated into any iOS application with enbedeed UI components(only for SwiftUI).

## Features

- ✅ Get Shakespearean translations of Pokémon descriptions
- ✅ Fetch Pokémon sprites by name
- ✅ Built-in UI components for displaying descriptions and sprites
- ✅ Support for both Combine and async/await
- ✅ Comprehensive error handling
- ✅ Image/Requestes caching for better performance

## Requirements

- iOS 15.0+
- Swift 5.5+
- Xcode 14.0+

## Installation

### Swift Package Manager

Add TruePokemonSDK to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/Zeno995/TruePokemon.git", from: "1.0.0")
]
```

Or in Xcode:
1. Go to File > Swift Packages > Add Package Dependency...
2. Enter the repository URL
3. Select the version you want to use

### Using Tuist

If you're using [Tuist](https://tuist.io) to manage your project, you can add TruePokemonSDK as a dependency in your `Project.swift` file:

```swift
let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/Zeno995/TruePokemon.git", requirement: .upToNextMajor(from: "1.0.0")),
    ],
    platforms: [.iOS]
)
```

Then in your target dependencies:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .external(name: "TruePokemonSDK")
    ],
    // ...
)
```

## Usage

### Initialization

```swift
import TruePokemonSDK

let pokemonSDK = TruePokemonSDK()
```

### Verifying if a Pokémon exists

#### Using Combine

```swift
pokemonSDK.verifyPokemon(from: "pikachu")
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("Error:", error)
            }
        },
        receiveValue: { isVerified in
            print("Pokémon exists:", isVerified)
        }
    )
    .store(in: &cancellables)
```

#### Using async/await

```swift
Task {
    do {
        let isVerified = try await pokemonSDK.verifyPokemon(from: "pikachu")
        print("Pokémon exists:", isVerified)
    } catch {
        print("Error:", error)
    }
}
```

### Getting a Pokémon's sprite URL

#### Using Combine

```swift
pokemonSDK.getPokemonSpriteURL(from: "charizard")
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("Error:", error)
            }
        },
        receiveValue: { url in
            print("Sprite URL:", url)
        }
    )
    .store(in: &cancellables)
```

#### Using async/await

```swift
Task {
    do {
        let url = try await pokemonSDK.getPokemonSpriteURL(from: "charizard")
        print("Sprite URL:", url)
    } catch {
        print("Error:", error)
    }
}
```

### Getting a Shakespearean translation of a Pokémon's description

#### Using Combine

```swift
pokemonSDK.getShakespeareTranslation(from: "bulbasaur")
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("Error:", error)
            }
        },
        receiveValue: { translation in
            print("Shakespearean description:", translation)
        }
    )
    .store(in: &cancellables)
```

#### Using async/await

```swift
Task {
    do {
        let translation = try await pokemonSDK.getShakespeareTranslation(from: "bulbasaur")
        print("Shakespearean description:", translation)
    } catch {
        print("Error:", error)
    }
}
```

### UI Components

#### ShakespeareView

Display a Pokémon's Shakespearean description:

```swift
import SwiftUI
import TruePokemonSDK

struct ContentView: View {
    var body: some View {
        ShakespeareView(name: "bulbasaur")
            .isAnimated(true)  // Optional: enable animations
            .isColored(true)   // Optional: enable colors
            .frame(height: 200)
    }
}
```

#### SpriteView

Display a Pokémon's sprite:

```swift
import SwiftUI
import TruePokemonSDK

struct ContentView: View {
    var body: some View {
        SpriteView(name: "bulbasaur")
            .frame(width: 200, height: 200)
        
        // Or with a direct URL
        SpriteView(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!)
            .frame(width: 200, height: 200)
    }
}
```

### Public Layer
Exposes the public API and UI components:
- `TruePokemonSDK.swift`: Main entry point for the SDK.
- `ShakespeareView`: UI component for displaying Shakespearean descriptions(Only for SwiftUI).
- `SpriteView`: UI component for displaying Pokémon sprites(Only for SwiftUI).

### Networking Layer
Handles all HTTP requests and API interactions:
- `NetworkService`: Implements the logic for making HTTP requests.
- `NetworkCache`: Manages response caching for improved performance.
- Specialized services: `PokemonService` and `ShakespeareService` for interacting with APIs.

### Model Layer
Defines data models used internally by the SDK, with clear separation between:
- Response models: Direct mappings from API responses and normalized in app models.
- App models: Domain models used within the SDK.

## Error Handling

The SDK provides comprehensive error handling through `TruePokemonSDKError`:

```swift
public enum TruePokemonSDKError: Error {
    case pokemonNotFound
    case serviceError(Networking.ServiceError)
    case responseError
    case unknown
}
```

This allows for precise identification and handling of different errors that may occur when using the SDK.

## API References

The SDK uses the following external APIs:
- [PokéAPI](https://pokeapi.co/docs/v2): For fetching Pokémon information and sprites
- [Shakespeare Translator API](https://funtranslations.com/api/shakespeare): For translating Pokémon descriptions into Shakespearean style

## Dependencies

- [Nuke](https://github.com/kean/Nuke): For efficient image loading and caching
- [NukeUI](https://github.com/kean/NukeUI): For SwiftUI integration with Nuke
