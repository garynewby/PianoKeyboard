//
//  ContentView.swift
//  Example
//
//  Created by Gary Newby on 05/04/2023.
//

import SwiftUI
import PianoKeyboard

struct ContentView: View {

    @Bindable private var viewModel: PianoKeyboardViewModel
    @State private var styleIndex: Int
    private let audioEngine: AudioEngine

    init(
        viewModel: PianoKeyboardViewModel,
        audioEngine: AudioEngine,
        styleIndex: Int
    ) {
        self.viewModel = viewModel
        self.audioEngine = audioEngine
        self.styleIndex = styleIndex
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: Gradient(stops: [
                                Gradient.Stop(color: Color(white: 0.2), location: 0),
                                    Gradient.Stop(color: Color(white: 0.3), location: 0.96),
                                    Gradient.Stop(color: .black, location: 1),
                                ]), startPoint: .top, endPoint: .bottom)
                        )
                        .shadow(radius: 8)

                    VStack {
                        HStack(spacing: 30) {
                            Stepper("Keys") {
                                viewModel.numberOfKeys += 1
                            } onDecrement: {
                                viewModel.numberOfKeys -= 1
                            }
                            .frame(width: 150)

                            Stepper("Style", value: $styleIndex, in: 0...2)
                                .frame(width: 150)

                            Toggle("Latch", isOn: $viewModel.latch)
                                .toggleStyle(.switch)
                                .tint(.blue)
                                .frame(width: 120)
                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .padding(20)

                        HStack {
                            HStack {
                                Text("Notes:")
                                Text("\(viewModel.keysPressed.joined(separator: ", "))")
                            }
                            .padding(20)

                            Spacer()

                            Text("PianoKeyboard")
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .padding(20)
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.45)

                if styleIndex == 0 {
                    PianoKeyboardView(viewModel: viewModel, style: ClassicStyle(sfKeyWidthMultiplier: 0.55))
                        .frame(height: geometry.size.height * 0.55)
                } else if styleIndex == 1 {
                    PianoKeyboardView(viewModel: viewModel, style: ModernStyle())
                        .frame(height: geometry.size.height * 0.55)
                } else if styleIndex == 2{
                    PianoKeyboardView(viewModel: viewModel, style: CustomStyle(showLabels: true))
                        .frame(height: geometry.size.height * 0.55)
                }
            }
            .background(.black)
        }
        .onAppear() {
            viewModel.delegate = audioEngine
            audioEngine.start()
        }
    }
}

#Preview(traits: .landscapeRight) {
    @Previewable @State var viewModel = PianoKeyboardViewModel()
    @Previewable @State var audioEngine = AudioEngine()

    ContentView(viewModel: viewModel, audioEngine: audioEngine, styleIndex: 0)
}
