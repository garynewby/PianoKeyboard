//
//  TouchesView.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 20/03/2023.
//

import SwiftUI
import UIKit

struct TouchesView: UIViewRepresentable {
    var viewModel: PianoKeyboardViewModel

    func makeUIView(context: Context) -> TouchesUIView {
        let touchesUIView = TouchesUIView()
        touchesUIView.isMultipleTouchEnabled = true
        touchesUIView.delegate = context.coordinator
        return touchesUIView
    }

    func updateUIView(_ uiView: TouchesUIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, TouchesUIViewDelegate {
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

protocol TouchesUIViewDelegate: AnyObject {
    var touches: [CGPoint] { get set }
}

class TouchesUIView: UIView {
    static var minNumberOfKeys: Int = 12
    static var maxNumberOfKeys: Int = 61

    weak var delegate: TouchesUIViewDelegate?
    var currentTouches = NSMutableSet(capacity: Int(maxNumberOfKeys))

    func updateKeys() {
        if let touches = currentTouches.allObjects as? [UITouch] {
            let points = touches.map { $0.location(in: nil) }
            delegate?.touches = points
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            currentTouches.add(touch)
        }
        updateKeys()
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            currentTouches.add(touch)
        }
        updateKeys()
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            currentTouches.remove(touch)
        }
        updateKeys()
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            currentTouches.remove(touch)
        }
        updateKeys()
    }
}
