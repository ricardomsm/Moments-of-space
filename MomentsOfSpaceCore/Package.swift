// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MomentsOfSpaceCore",
	platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "LocationAwareMeditationsFeature", targets: ["LocationAwareMeditationsFeature"]),
    ],
    dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.2.0"),
		.package(url: "https://github.com/ricardomsm/Networking", branch: "main"),
    ],
    targets: [
        .target(
            name: "LocationAwareMeditationsFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				.product(name: "Networking", package: "Networking")
			],
			resources: [.process("Resources")]
		),
        .testTarget(
            name: "LocationAwareMeditationsFeatureTests",
            dependencies: ["LocationAwareMeditationsFeature"]
		),
    ]
)
