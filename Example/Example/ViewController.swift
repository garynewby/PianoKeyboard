//
//  ViewController.swift
//  Example
//
//  Created by gary on 17/05/2016.
//  Copyright © 2016 Gary Newby. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, GLNPianoViewDelegate {
    @IBOutlet private var fascia: UIView!
    @IBOutlet private var keyboard: GLNPianoView!
    @IBOutlet private var keyNumberStepper: UIStepper!
    @IBOutlet private var keyNumberLabel: UILabel!
    @IBOutlet private var octaveStepper: UIStepper!
    @IBOutlet private var octaveLabel: UILabel!
    @IBOutlet private var showNotesSwitch: UISwitch!
    @IBOutlet private var latchSwitch: UISwitch!

    private let audioEngine = AudioEngine()
    private var sequence: Sequence?
    private lazy var fasciaLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = fascia.bounds
        layer.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.darkGray.cgColor, UIColor.black.cgColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.80)
        layer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return layer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboard.delegate = self

        // Custom labels
        keyboard.setLabel(for: 60, text: "Do")
        keyboard.setLabel(for: 62, text: "Re")
        keyboard.setLabel(for: 64, text: "Mi")

        for noteNumber in 65...72 {
            keyboard.setLabel(for: noteNumber, text: GLNNote.name(for: noteNumber))
        }

        keyNumberStepper.value = Double(keyboard.numberOfKeys)
        keyNumberLabel.text = String(keyNumberStepper.value)
        keyNumberStepper.layer.cornerRadius = 8.0
        keyNumberStepper.layer.masksToBounds = true

        octaveStepper.layer.cornerRadius = 8.0
        octaveStepper.layer.masksToBounds = true
        octaveLabel.text = String(octaveStepper.value)

        showNotesSwitch.subviews[0].subviews[0].backgroundColor = .gray
        latchSwitch.subviews[0].subviews[0].backgroundColor = .gray

        audioEngine.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        keyboard.highlightKey(noteNumber: 72, color: UIColor.red.withAlphaComponent(0.7), resets: false)
        keyboard.highlightKey(noteNumber: 75, color: UIColor.red.withAlphaComponent(0.7), resets: false)
        keyboard.highlightKey(noteNumber: 79, color: UIColor.red.withAlphaComponent(0.7), resets: false)

        fascia.layer.insertSublayer(fasciaLayer, at: 0)

        // Auto highlighting/playing examples
        noteDemo()
        //chordDemo()
    }


    private func chordDemo() {
        autoHighlight(score: [["C4", "E4", "G4", "B4"],
                              ["D4", "F#4", "A4"],
                              ["E4", "G4", "B4"],
                              ["D4", "F#4", "A4"]
                   ], position: 0, loop: true, tempo: 90.0, play: true)
    }

    private func noteDemo() {
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

    func pianoKeyDown(_ keyNumber: Int) {
        audioEngine.sampler.startNote(UInt8(keyboard.octave + keyNumber), withVelocity: 64, onChannel: 0)
    }

    func pianoKeyUp(_ keyNumber: Int) {
        audioEngine.sampler.stopNote(UInt8(keyboard.octave + keyNumber), onChannel: 0)
    }

    @IBAction func latchTapped(_ sender: Any) {
        keyboard.toggleLatch()
    }

    @IBAction func showNotesTapped(_: Any) {
        keyboard.toggleShowNotes()
    }

    @IBAction func keyNumberStepperTapped(_ sender: UIStepper) {
        keyboard.numberOfKeys = Int(sender.value)
        keyNumberLabel.text = String(keyNumberStepper.value)
    }

    @IBAction func octaveStepperTapped(_ sender: UIStepper) {
        keyboard.octave = Int(sender.value)
        octaveLabel.text = String(keyboard.octave)
    }
}

