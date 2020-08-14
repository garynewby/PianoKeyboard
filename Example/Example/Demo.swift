//
//  Demo.swift
//  Example
//
//  Created by Gary Newby on 14/08/2020.
//  Copyright © 2020 Gary Newby. All rights reserved.
//

import UIKit

class Demo {
    private let keyboard: PianoKeyboard
    private var sequence: Sequence?

    init(keyboard: PianoKeyboard) {
        self.keyboard = keyboard
        setUp()
    }

    private func setUp() {
        // Custom labels
        keyboard.setLabel(for: 60, text: "Do")
        keyboard.setLabel(for: 62, text: "Re")
        keyboard.setLabel(for: 64, text: "Mi")

        for noteNumber in 65...72 {
            keyboard.setLabel(for: noteNumber, text: Note.name(for: noteNumber))
        }

        keyboard.highlightKey(noteNumber: 72, color: UIColor.red.withAlphaComponent(0.7), resets: false)
        keyboard.highlightKey(noteNumber: 75, color: UIColor.red.withAlphaComponent(0.7), resets: false)
        keyboard.highlightKey(noteNumber: 79, color: UIColor.red.withAlphaComponent(0.7), resets: false)
    }

    func chords() {
        autoHighlight(score: [["C4", "E4", "G4", "B4"],
                              ["D4", "F#4", "A4"],
                              ["E4", "G4", "B4"],
                              ["D4", "F#4", "A4"]
                   ], position: 0, loop: true, tempo: 90.0, play: true)
    }

    func notes() {
        let alpha: CGFloat = 0.7
        sequence = Sequence(delay: 0.5, functions: {
            self.keyboard.highlightKey(noteNumber: 60, color: UIColor.red.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 61, color: UIColor.blue.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 62, color: UIColor.green.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 63, color: UIColor.yellow.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 64, color: UIColor.orange.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 65, color: UIColor.purple.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 66, color: UIColor.red.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 67, color: UIColor.blue.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 68, color: UIColor.green.withAlphaComponent(alpha))
        })
    }

    private func autoHighlight(score: [[String]], position: Int, loop: Bool, tempo: Double, play: Bool = false) {
        keyboard.highlightKeys(noteNames: score[position], color: UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.35), play: play)
        let delay = 60.0/tempo
        let nextPosition = position + 1
        if nextPosition < score.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.autoHighlight(score: score, position: nextPosition, loop: loop, tempo: tempo, play: play)
            }
        } else {
            if loop {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                    self?.autoHighlight(score: score, position: 0, loop: loop, tempo: tempo, play: play)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                    self?.keyboard.reset(didPlay: play)
                }
            }
        }
    }
}
