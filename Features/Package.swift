// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    defaultLocalization: "en",
    platforms: [.iOS(.v26)],
    products: [
        .library(
            name: "APIClient",
            targets: ["APIClient"]
        ),
        .library(
            name: "APIClientLive",
            targets: ["APIClientLive"]
        ),
        .library(
            name: "APIKeyClient",
            targets: ["APIKeyClient"]
        ),
        .library(
            name: "APIKeyClientLive",
            targets: ["APIKeyClientLive"]
        ),
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
        .library(
            name: "AstronomyPicture",
            targets: ["AstronomyPicture"]
        ),
        .library(
            name: "DateFormatting",
            targets: ["DateFormatting"]
        ),
        .library(
            name: "Models",
            targets: ["Models"]
        ),
        .library(
            name: "Settings",
            targets: ["Settings"]
        ),
        .library(
            name: "SharedUI",
            targets: ["SharedUI"]
        ),
        .library(
            name: "SpaceWeather",
            targets: ["SpaceWeather"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/cybozu/LicenseList.git", exact: "2.3.0"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "1.25.5"
        ),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.12.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        .package(url: "https://github.com/konomae/swift-local-date.git", from: "0.5.0"),
    ],
    targets: [
        .target(
            name: "APIClient",
            dependencies: [
                "Models",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "APIClientLive",
            dependencies: [
                "APIClient",
                "APIKeyClientLive",
                "DateFormatting",
                .product(name: "LocalDate", package: "swift-local-date"),
            ]
        ),
        .target(
            name: "APIKeyClient",
            dependencies: [
                "Models",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "APIKeyClientLive",
            dependencies: [
                "APIKeyClient",
                .product(name: "KeychainAccess", package: "KeychainAccess"),
            ]
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "AstronomyPicture",
                "Settings",
                "SpaceWeather",
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]
        ),
        .target(
            name: "AstronomyPicture",
            dependencies: [
                "APIClient",
                "SharedUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "AstronomyPictureTests",
            dependencies: ["AstronomyPicture"]
        ),
        .target(
            name: "DateFormatting",
            dependencies: []
        ),
        .testTarget(
            name: "DateFormattingTests",
            dependencies: ["DateFormatting"]
        ),
        .target(
            name: "Models",
            dependencies: [
                .product(name: "LocalDate", package: "swift-local-date")
            ]
        ),
        .testTarget(
            name: "ModelsTests",
            dependencies: ["Models"]
        ),
        .target(
            name: "Settings",
            dependencies: [
                "APIClient",
                "APIKeyClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "LicenseList", package: "LicenseList"),
            ],
        ),
        .testTarget(
            name: "SettingsTests",
            dependencies: ["Settings"]
        ),
        .target(
            name: "SharedUI",
            dependencies: []
        ),
        .target(
            name: "SpaceWeather",
            dependencies: [
                "APIClient",
                "SharedUI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "SpaceWeatherTests",
            dependencies: ["SpaceWeather"]
        ),
    ]
)
