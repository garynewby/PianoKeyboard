//
//  Midi.swift
//  Example
//
//  Created by Gary Newby on 23/09/2017.
//  Copyright © 2017 Gary Newby. All rights reserved.
//

import UIKit
import QuartzCore


class GLNPianoHelper {
    
    static func noteStringFor(midiNumber: Int) -> String {
        let index = Int(midiNumber)
        let notesArray = [
            "C-1", "C#-1", "D-1", "Eb-1", "E-1", "F-1", "F#-1", "G-1", "Ab-1", "A-1", "Bb-1", "B-1",
            "C0", "C#0", "D0", "Eb0", "E0", "F0", "F#0", "G0", "Ab0", "A0", "Bb0", "B0",
            "C1", "C#1", "D1", "Eb1", "E1", "F1", "F#1", "G1", "Ab1", "A1", "Bb1", "B1",
            "C2", "C#2", "D2", "Eb2", "E2", "F2", "F#2", "G2", "Ab2", "A2", "Bb2", "B2",
            "C3", "C#3", "D3", "Eb3", "E3", "F3", "F#3", "G3", "Ab3", "A3", "Bb3", "B3",
            "C4", "C#4", "D4", "Eb4", "E4", "F4", "F#4", "G4", "Ab4", "A4", "Bb4", "B4",
            "C5", "C#5", "D5", "Eb5", "E5", "F5", "F#5", "G5", "Ab5", "A5", "Bb5", "B5",
            "C6", "C#6", "D6", "Eb6", "E6", "F6", "F#6", "G6", "Ab6", "A6", "Bb6", "B6",
            "C7", "C#7", "D7", "Eb7", "E7", "F7", "F#7", "G7", "Ab7", "A7", "Bb7", "B7",
            "C8", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
        return "\(notesArray[index])"
    }
    
    static func noteColourFor(midiNumber: Int, alpha: Float) -> UIColor {
        let hue = (CGFloat(midiNumber).truncatingRemainder(dividingBy: 12.0) / 12.0)
        return UIColor(hue: hue, saturation: 0.0, brightness: 0.40, alpha: CGFloat(alpha))
    }
    
    static func clamp(_ value:Int, min:Int,  max:Int) -> Int {
        let r = value < min ? min : value;
        return r > max ? max : r;
    }
}

class VerticallyCenteredTextLayer : CATextLayer {
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: (self.bounds.size.height - self.fontSize)/2.0 - self.fontSize/10.0)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}

extension Int {
    
    func isWhiteKey() -> Bool {
        let k = self % 12
        return (k == 0 || k == 2 || k == 4 || k == 5 || k == 7 || k == 9 || k == 11)
    }
    
}


