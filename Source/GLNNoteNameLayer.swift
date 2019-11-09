//
//  GLNNoteLayer.swift
//  Example
//
//  Created by Gary Newby on 6/11/19.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import UIKit
import QuartzCore

public final class GLNNoteNameLayer: CATextLayer {
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public init(layerHeight: CGFloat, keyRect: CGRect, noteNumber: Int) {
        super.init()
        let width = keyRect.size.width / 2.0
        let height = width
        self.string = Note.name(of: noteNumber)
        self.foregroundColor = UIColor.white.cgColor
        self.backgroundColor = UIColor.noteColourFor(midiNumber: noteNumber, alpha: 0.75).cgColor
        self.font = UIFont.boldSystemFont(ofSize: 0.0)
        self.fontSize = (keyRect.size.width / 4.0)
        self.alignmentMode = .center
        self.cornerRadius = (height * 0.5)
        self.frame = CGRect(x: (keyRect.size.width * 0.25), y: (layerHeight - height - 10), width: width, height: height)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func draw(in ctx: CGContext) {
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: (bounds.size.height - fontSize) / 2.0 - fontSize / 10.0)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
