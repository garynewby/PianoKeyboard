// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "PianoView",
    platforms: [
        .iOS("9.0")
    ],
    products: [
        .library(
            name: "PianoView",
            targets: ["PianoView"]
        )
    ],
    targets: [
        .target(
            name: "PianoView",
            path: "Source"
        )
    ]
)
