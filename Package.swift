// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Utilities
public enum UpcomingFeatures: String, CaseIterable {
    case existentialAny
    case fullTypedThrows
    case internalImportsByDefault
    case memberImportVisibility
    case nonescapableTypes
    case nonisolatedNonsendingByDefault
    case inferIsolatedConformances
    case valueGenerics

    var asSetting: SwiftSetting { .enableUpcomingFeature(rawValue.prefix(1).uppercased() + rawValue.dropFirst()) }
}

public extension Array where Element == SwiftSetting {
    static var upcomingFeatures: Self { UpcomingFeatures.allCases.map(\.asSetting) }
}

func dep(local: String) -> Package.Dependency {
    .package(path: local)
}

func dep(url: String, _ version: Range<Version>, local: String = "") -> Package.Dependency {
    if local.isEmpty {
        .package(url: url, version)
    } else {
        dep(local: local)
    }
}

func lib(_ name: String, targets: String...) -> Product {
    .library(name: name, targets: targets)
}

func platformDeps(_ platforms: SupportedPlatform...) -> [SupportedPlatform] {
    platforms
}
func targetDep(name: String, package: String) -> Target.Dependency {
    .product(name: name, package: package)
}

// MARK: - Dependencies
let nonempty = targetDep(name: "NonEmpty", package: "swift-nonempty")
let numerics = targetDep(name: "Numerics", package: "swift-numerics")
let graphs = targetDep(name: "Graphs", package: "swift-graphs")

let dependencies = [
    dep(url: "https://github.com/pointfreeco/swift-nonempty", .upToNextMajor(from: "0.5.0")),
    dep(url: "https://github.com/apple/swift-numerics", .upToNextMajor(from: "1.1.0")),
    dep(url: "https://github.com/tevelee/swift-graphs", .upToNextMajor(from: "0.0.1"))
]

// MARK: - Targets
let targets: [Target] = [
    .target(
        name: "Mathe",
        dependencies: ["MatheCoordinates", "MatheGraphs", "MatheSIMD"],
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "MatheCoordinates",
        dependencies: [numerics],
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "MatheGraphs",
        dependencies: [graphs, nonempty],
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "MatheSIMD",
        dependencies: [numerics],
        swiftSettings: .upcomingFeatures
    )
]

let testTargets: [Target] = targets.map { t in
    .testTarget(name: "\(t.name)Tests", dependencies: [Target.Dependency(stringLiteral: t.name)] + t.dependencies)
}

// MARK: - Products
let products: [Product] = [
    .library(
        name: "Mathe",
        targets: ["Mathe", "MatheCoordinates", "MatheGraphs", "MatheSIMD"]
    )
]

// MARK: - Supported Platforms
let platforms = platformDeps(.macOS(.v10_15))

// MARK: - PackageDescription
let package = Package(
    name: "Mathe",
    platforms: platforms,
    products: products,
    dependencies: dependencies,
    targets: targets + testTargets,
    swiftLanguageModes: [.v6]
)
