// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "PianoKeyboard",
    platforms: [
        .iOS("15.0")
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
            dependencies: [],
            path: "Source"
        ),
        .testTarget(
            name: "PianoKeyboardTests",
            dependencies: [
                "PianoKeyboard"
            ])
    ]
)
