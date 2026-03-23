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
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        view.isOpaque = false
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: TouchesUIView, context: Context) {
        context.coordinator.parent = self
    }

    static func sizeThatFits(_ proposal: ProposedViewSize, uiView: TouchesUIView, context: Context) -> CGSize? {
        guard let width = proposal.width, let height = proposal.height else { return nil }
        return CGSize(width: width, height: height)
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
        isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        isOpaque = false
        isUserInteractionEnabled = true
    }

    private func updateKeys() {
        let points = currentTouches.map { $0.location(in: self) }
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
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
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
