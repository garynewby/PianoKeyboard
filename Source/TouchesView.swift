//
//  TouchesView.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 20/03/2023.
//

import SwiftUI

#if os(iOS)
import UIKit

struct TouchesView: UIViewRepresentable {
    var viewModel: PianoKeyboardViewModel

    func makeUIView(context: Context) -> TouchesUIView {
        let view = TouchesUIView()
        view.isMultipleTouchEnabled = true
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: TouchesUIView, context: Context) {
        context.coordinator.parent = self
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, TouchesViewDelegate {
        var parent: TouchesView
        var touches: [CGPoint] = [] {
            didSet {
                parent.viewModel.touches = touches
            }
        }

        init(_ parent: TouchesView) {
            self.parent = parent
        }
    }
}

final class TouchesUIView: UIView {
    weak var delegate: TouchesViewDelegate?
    private var currentTouches = Set<UITouch>()

    private func updateKeys() {
        let points = currentTouches.map { $0.location(in: nil) }
        delegate?.touches = points
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTouches.formUnion(touches)
        updateKeys()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTouches.formUnion(touches)
        updateKeys()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTouches.subtract(touches)
        updateKeys()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTouches.subtract(touches)
        updateKeys()
    }
}
#else
struct TouchesView: View {
    var viewModel: PianoKeyboardViewModel

    var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onChanged { value in
                        viewModel.touches = [value.location]
                    }
                    .onEnded { _ in
                        viewModel.touches = []
                    }
            )
            .onHover { isInside in
                if !isInside {
                    viewModel.touches = []
                }
            }
    }
}
#endif

protocol TouchesViewDelegate: AnyObject {
    var touches: [CGPoint] { get set }
}
