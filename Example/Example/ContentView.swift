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

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(gradient: Gradient(stops: [
                            Gradient.Stop(color: Color(white: 0.2), location: 0),
                                Gradient.Stop(color: Color(white: 0.3), location: 0.96),
                                Gradient.Stop(color: .black, location: 1),
                            ]), startPoint: .top, endPoint: .bottom)
                    )
                    .shadow(radius: 8)

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Stepper("Keys: \(pianoKeyboardViewModel.numberOfKeys)") {
                            pianoKeyboardViewModel.numberOfKeys += 1
                        } onDecrement: {
                            pianoKeyboardViewModel.numberOfKeys -= 1
                        }
                        .font(.body.bold())
                        .foregroundColor(.white)

                        Toggle("Latch:", isOn: $pianoKeyboardViewModel.latch)
                            .font(.body.bold())
                            .foregroundColor(.white)

                        Stepper("Style:", value: $styleIndex, in: 0...2)
                            .font(.body.bold())
                            .foregroundColor(.white)
                            .tint(.blue)
                    }
                    .frame(width: 190)
                    Spacer()
                    Text("PianoKeyboard")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                }
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 30))
            }

            if styleIndex == 0 {
                PianoKeyboardView(viewModel: pianoKeyboardViewModel, style: ClassicStyle(sfKeyWidthMultiplier: 0.55))
                    .frame(height: 230)
            } else if styleIndex == 1 {
                PianoKeyboardView(viewModel: pianoKeyboardViewModel, style: ModernStyle())
                    .frame(height: 230)
            } else if styleIndex == 2{
                PianoKeyboardView(viewModel: pianoKeyboardViewModel, style: CustomStyle())
                    .frame(height: 230)
            }
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
        .previewInterfaceOrientation(.landscapeLeft)
    }
}

