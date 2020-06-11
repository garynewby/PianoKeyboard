// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "PianoKeyboard",
    platforms: [
        .iOS("9.0")
    ],
    products: [
        .library(
            name: "PianoKeyboard",
            targets: ["PianoKeyboard"]
        )
    ],
    targets: [
        .target(
            name: "PianoKeyboard",
            path: "Source"
        )
    ]
)
