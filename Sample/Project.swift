import ProjectDescription

let projectName = "TruePokemonSampleApp"
let organizationName = "EC"
let bundleId = "ec.truepokemon.sample"
let deploymentTargets = DeploymentTargets.iOS("15.0")
let destinations: Set<Destination> = [.iPhone, .iPad]

// MARK: - Sample App Target

let sampleAppTarget: Target = .target(
    name: "TruePokemonSampleApp",
    destinations: destinations,
    product: .app,
    bundleId: bundleId,
    deploymentTargets: deploymentTargets,
    infoPlist: .extendingDefault(with: [
        "UILaunchStoryboardName": "LaunchScreen",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ]
                ]
            ]
        ]
    ]),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    dependencies: [
        .external(name: "TruePokemonSDK")
    ]
)

// MARK: - Project

let project = Project(
    name: projectName,
    organizationName: organizationName,
    options: .options(
        automaticSchemesOptions: .disabled,
        disableBundleAccessors: false,
        disableSynthesizedResourceAccessors: false
    ),
    packages: [
        .local(path: "..")
    ],
    settings: .settings(
        base: [:],
        configurations: [
            .debug(name: "Debug", settings: [:], xcconfig: nil),
            .release(name: "Release", settings: [:], xcconfig: nil)
        ],
        defaultSettings: .recommended
    ),
    targets: [
        sampleAppTarget
    ],
    schemes: [
        .scheme(
          name: "TruePokemonSampleApp",
          buildAction: .buildAction(targets: ["TruePokemonSampleApp"]),
          runAction: .runAction(configuration: "Debug"),
          archiveAction: .archiveAction(configuration: "Release", revealArchiveInOrganizer: true),
          profileAction: .profileAction(configuration: "Release"),
          analyzeAction: .analyzeAction(configuration: "Debug")
        )
    ],
    fileHeaderTemplate: nil,
    additionalFiles: [],
    resourceSynthesizers: []
) 