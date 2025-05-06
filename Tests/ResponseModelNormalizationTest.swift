//
//  ResponseModelNormalizationTest.swift
//  TruePokemonSDK
//
//  Created by Enzo on 06/05/25.
//

import Foundation
import Nimble
import XCTest
@testable import TruePokemonSDK

class ResponseModelNormalizationTest: XCTestCase {
  func test_pokemonResponseNormalization_success() {
    let detail = Model.Response.Pokemon.Detail(
      id: 25,
      name: "pikachu",
      types: [
        Model.Response.Pokemon.Detail.Kind(
          name: "electric",
          url: "https://pokeapi.co/api/v2/type/13/"
        )
      ],
      sprites: Model.Response.Pokemon.Detail.Sprite(
        frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png"
      ),
      species: Model.Response.Pokemon.Detail.Species(
        url: "https://pokeapi.co/api/v2/pokemon-species/25/"
      )
    )
    
    let species = Model.Response.Pokemon.Species(
      flavorTextEntries: [
        Model.Response.Pokemon.Species.Flavor(
          text: "When several of\nthese POKéMON\ngather, theirfelectricity could\nbuild and cause\nlightning storms.",
          languageName: "en"
        ),
        Model.Response.Pokemon.Species.Flavor(
          text: "Quand plusieurs de ces\nPOKéMON se réunissent,\nleur électricité peut\nprovoquer de violents orages.",
          languageName: "fr"
        )
      ])
    
    let pokemonResponse = Model.Response.Pokemon(detail: detail, species: species)
    let normalizedPokemon = pokemonResponse.normalizedForApp()
    
    expect(normalizedPokemon.id).to(equal(25))
    expect(normalizedPokemon.name).to(equal("pikachu"))
    expect(normalizedPokemon.description).to(equal("When several of\nthese POKéMON\ngather, theirfelectricity could\nbuild and cause\nlightning storms."))
    expect(normalizedPokemon.imageUrl?.absoluteString).to(equal("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png"))
  }
  
  func test_pokemonResponseNormalization_invalidImageURL() {
    let detail = Model.Response.Pokemon.Detail(
      id: 25,
      name: "pikachu",
      types: [
        Model.Response.Pokemon.Detail.Kind(
          name: "electric",
          url: "https://pokeapi.co/api/v2/type/13/"
        )
      ],
      sprites: Model.Response.Pokemon.Detail.Sprite(
        frontDefault: "Not a valid URL"
      ),
      species: Model.Response.Pokemon.Detail.Species(
        url: "https://pokeapi.co/api/v2/pokemon-species/25/"
      )
    )
    
    let species = Model.Response.Pokemon.Species(
      flavorTextEntries: [
        Model.Response.Pokemon.Species.Flavor(
          text: "When several of\nthese POKéMON\ngather, theirfelectricity could\nbuild and cause\nlightning storms.",
          languageName: "en"
        )
      ]
    )
    
    let pokemonResponse = Model.Response.Pokemon(detail: detail, species: species)
    let normalizedPokemon = pokemonResponse.normalizedForApp()
    
    expect(normalizedPokemon.id).to(equal(25))
    expect(normalizedPokemon.name).to(equal("pikachu"))
    expect(normalizedPokemon.description).to(equal("When several of\nthese POKéMON\ngather, theirfelectricity could\nbuild and cause\nlightning storms."))
    expect(detail.sprites.frontDefault).toNot(beNil())
  }
  
  func test_shakespeareResponseNormalization_success() {
    let shakespeareResponse = Model.Response.Shakespeare.Translate(text: "This is the original text")
    let normalizedShakespeare = shakespeareResponse.normalizedForApp()
    expect(normalizedShakespeare.text).to(equal("This is the original text"))
  }
}
