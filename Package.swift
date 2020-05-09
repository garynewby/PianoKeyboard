// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "GLNPianoView",
    platforms: [
        .iOS("9.0")
    ],
    products: [
        .library(
            name: "GLNPianoView",
            targets: ["GLNPianoView"]
        )
    ],
    targets: [
        .target(
            name: "GLNPianoView",
            path: "Source"
        )
    ]
)
