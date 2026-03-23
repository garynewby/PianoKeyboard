//
//  ExampleApp.swift
//  Example
//
//  Created by Gary Newby on 05/04/2023.
//

import SwiftUI
import PianoKeyboard

@main
struct ExampleApp: App {
    let viewModel: PianoKeyboardViewModel = .init()
    let audioEngine: AudioEngine = .init()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel, audioEngine: audioEngine, styleIndex: 0)
        }
    }
}
