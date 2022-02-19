//
//  ContentView.swift
//  Example
//
//  Created by Gary Newby on 05/04/2023.
//

import SwiftUI
import PianoKeyboard

struct ContentView: View {
    @ObservedObject private var pianoKeyboardViewModel = PianoKeyboardViewModel()
    @State var styleIndex: Int = 0

    private let audioEngine = AudioEngine()
    private let styles: [AnyKeyboardStyle] = [
        AnyKeyboardStyle(style: ClassicStyle(sfKeyWidthMultiplier: 0.55)),
        AnyKeyboardStyle(style: ModernStyle()),
        AnyKeyboardStyle(style: MyStyle()),
    ]

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .top, endPoint: .bottom))
                    .shadow(radius: 8)

                HStack {
                    VStack(alignment: .trailing) {
                        Stepper("Keys: \(pianoKeyboardViewModel.numberOfKeys)") {
                            pianoKeyboardViewModel.numberOfKeys += 1
                        } onDecrement: {
                            pianoKeyboardViewModel.numberOfKeys -= 1
                        }
                        .accentColor(.white)
                        .foregroundColor(.white)

                        Toggle("Latch:", isOn: $pianoKeyboardViewModel.latch)
                            .accentColor(.white)
                            .foregroundColor(.white)

                        Stepper("Style:", value: $styleIndex, in: 0...(styles.count - 1))
                            .foregroundColor(.white)
                            .accentColor(.white)
                    }
                    .frame(width: 250)
                    Spacer()
                }
                .padding(30)
            }

            //PianoKeyboardView(viewModel: pianoKeyboardViewModel)
            PianoKeyboardView(viewModel: pianoKeyboardViewModel, style: styles[styleIndex])
                .frame(height: 230)

        }
        .ignoresSafeArea()
        .onAppear() {
            pianoKeyboardViewModel.delegate = audioEngine
            audioEngine.start()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
        }
    }
}

