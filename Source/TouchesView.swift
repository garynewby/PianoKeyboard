//
//  TouchesView.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 20/03/2023.
//

import SwiftUI

#if !os(macOS)
public typealias PlatformView = UIView
public typealias PlatformViewRepresentable = UIViewRepresentable
#else
public typealias PlatformView = NSView
public typealias PlatformViewRepresentable = NSViewRepresentable
#endif

struct TouchesView: PlatformViewRepresentable {
    var viewModel: PianoKeyboardViewModel

    #if !os(macOS)

    func makeUIView(context: Context) -> PlatformView {
        let touchesUIView = TouchesPlatformView()
        touchesUIView.isMultipleTouchEnabled = true
        touchesUIView.delegate = context.coordinator
        return touchesUIView
    }

    func updateUIView(_ uiView: PlatformView, context: Context) {}

    #else

    func makeNSView(context: Context) -> PlatformView {
        let touchesNSView = TouchesPlatformView()
        touchesNSView.delegate = context.coordinator
        return touchesNSView
    }

    func updateNSView(_ uiView: PlatformView, context: Context) {}

    #endif

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, TouchesPlatformViewDelegate {
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

protocol TouchesPlatformViewDelegate: AnyObject {
    var touches: [CGPoint] { get set }
}

class TouchesPlatformView: PlatformView {
    static var minNumberOfKeys: Int = 12
    static var maxNumberOfKeys: Int = 61

    weak var delegate: TouchesPlatformViewDelegate?

    #if !os(macOS)

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

    #else

    public override func mouseDown(with event: NSEvent) {
        let windowMaxY = event.window?.frame.height ?? 0
        let click      = event.locationInWindow

        delegate?.touches = [CGPoint(x: click.x, y: windowMaxY-click.y)]
    }

    public override func mouseUp(with event: NSEvent) {
        delegate?.touches = []
    }

    #endif
}
