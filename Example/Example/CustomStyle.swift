//
//  MyStyle.swift
//  Example
//
//  Created by Gary Newby on 05/04/2023.
//

import SwiftUI
import PianoKeyboard

public struct CustomStyle: KeyboardStyle {
    public var showLabels: Bool = false
    public let naturalKeySpace: CGFloat = 2

    public func naturalColor(_ down: Bool) -> Color {
        down ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.4, green: 0.4, blue: 0.9)
    }

    public func sharpFlatColor(_ down: Bool) -> Color {
        down ? Color(red: 0.4, green: 0.4, blue: 0.4) : Color(red: 0.8, green: 0.2, blue: 0.2)
    }

    public func labelColor(_ noteNumber: Int) -> Color {
        Color(hue: Double(noteNumber) / 127.0, saturation: 1, brightness: 0.6)
    }

    public func naturalKeyWidth(_ width: CGFloat, naturalKeyCount: Int, space: CGFloat) -> CGFloat {
        (width - (space * CGFloat(naturalKeyCount - 1))) / CGFloat(naturalKeyCount)
    }

    public func layout(viewModel: PianoKeyboardViewModel, geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        applyKeyRects(viewModel: viewModel, width: width, height: height)

        return Canvas { context, size in
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.gray))

            for (index, key) in viewModel.keys.enumerated() {
                let rect = viewModel.keyRects[index]
                let path = Circle()
                    .path(in: rect)

                let backColor = key.isNatural ? naturalColor(key.touchDown) : sharpFlatColor(key.touchDown)
                context.fill(path, with: .color(backColor))

                if showLabels {
                    context.draw(
                        Text(key.name)
                            .font(.subheadline.bold())
                            .foregroundColor(.white),
                        at: CGPoint(x: rect.origin.x + rect.width / 2.0, y: rect.midY)
                    )
                }
            }
        }
    }

    private func applyKeyRects(viewModel: PianoKeyboardViewModel, width: CGFloat, height: CGFloat) {
        let count = viewModel.keys.count
        guard width > 0, height > 0, count > 0, viewModel.keyRects.count == count else { return }

        var rects = viewModel.keyRects
        let naturalWidth = naturalKeyWidth(width, naturalKeyCount: viewModel.naturalKeyCount, space: naturalKeySpace)
        let naturalXIncr = naturalWidth + naturalKeySpace
        var xpos: CGFloat = 0.0

        for (index, key) in viewModel.keys.enumerated() {
            rects[index] = CGRect(
                origin: CGPoint(x: xpos, y: key.isNatural ? 0 : -50),
                size: CGSize(width: naturalWidth, height: height)
            )
            xpos += naturalXIncr
        }

        viewModel.keyRects = rects
    }
}
