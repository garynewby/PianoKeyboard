//
//  NoteNameLayer.swift
//  Example
//
//  Created by Gary Newby on 6/11/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import UIKit
import QuartzCore

public final class NoteNameLayer: CATextLayer {
    public init(layerHeight: CGFloat, keyRect: CGRect, noteNumber: Int, label: String) {
        super.init()
        
        let width = keyRect.size.width / 2.0
        let height = width
        var yOffset: CGFloat = 20

        contentsScale = UIScreen.main.scale
        string = label
        foregroundColor = UIColor.white.cgColor

        if noteNumber.isWhiteKey() {
            backgroundColor = UIColor.noteColourFor(midiNumber: noteNumber, alpha: 0.75).cgColor
            cornerRadius = (height * 0.5)
            yOffset = 10
        }

        font = UIFont.boldSystemFont(ofSize: 0.0)
        fontSize = (keyRect.size.width / 4.0)
        alignmentMode = .center
        frame = CGRect(x: (keyRect.size.width * 0.25), y: (layerHeight - height - yOffset), width: width, height: height)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(in ctx: CGContext) {
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: (bounds.size.height - fontSize) / 2.0 - fontSize / 10.0)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
